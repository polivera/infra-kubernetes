# apps/backup/terraform/mysql-backup.tf
# MySQL backup cronjob (disabled by default)
resource "kubernetes_cron_job_v1" "mysql_backup" {
  count = var.mysql_backup_enabled ? 1 : 0

  metadata {
    name      = "mysql-backup"
    namespace = var.namespace
    labels = {
      app       = "mysql-backup"
      component = "backup"
      database  = "mysql"
    }
  }

  spec {
    schedule                      = var.mysql_backup_schedule
    timezone                      = module.globals.timezone
    successful_jobs_history_limit = 3
    failed_jobs_history_limit     = 3
    concurrency_policy            = "Forbid"

    job_template {
      metadata {
        labels = {
          app       = "mysql-backup"
          component = "backup"
          database  = "mysql"
        }
      }

      spec {
        backoff_limit              = 3
        ttl_seconds_after_finished = 86400 # 24 hours

        template {
          metadata {
            labels = {
              app       = "mysql-backup"
              component = "backup"
              database  = "mysql"
            }
          }

          spec {
            restart_policy = "OnFailure"

            container {
              name  = "mysql-backup"
              image = "mysql:8.4"

              command = ["/bin/bash"]
              args = [
                "-c",
                <<-EOT
                set -euo pipefail

                # Set variables
                TIMESTAMP=$(date +%Y%m%d_%H%M%S)
                BACKUP_DIR="/backup/mysql"
                BACKUP_FILE="$BACKUP_DIR/mysql_backup_$TIMESTAMP.sql"
                COMPRESSED_FILE="$BACKUP_FILE.gz"

                # Create backup directory
                mkdir -p "$BACKUP_DIR"

                echo "Starting MySQL backup at $(date)"
                echo "Host: $MYSQL_HOST:$MYSQL_PORT"
                echo "User: $MYSQL_USER"

                # Create backup
                mysqldump \
                  --host="$MYSQL_HOST" \
                  --port="$MYSQL_PORT" \
                  --user="$MYSQL_USER" \
                  --password="$MYSQL_PASSWORD" \
                  --single-transaction \
                  --routines \
                  --triggers \
                  --all-databases \
                  --verbose \
                  > "$BACKUP_FILE"

                # Compress backup
                gzip "$BACKUP_FILE"

                # Verify backup file exists and has content
                if [[ -f "$COMPRESSED_FILE" && -s "$COMPRESSED_FILE" ]]; then
                  echo "Backup completed successfully: $COMPRESSED_FILE"
                  echo "Backup size: $(du -h "$COMPRESSED_FILE" | cut -f1)"
                else
                  echo "ERROR: Backup file is missing or empty"
                  exit 1
                fi

                # Cleanup old backups
                echo "Cleaning up backups older than $${RETENTION_DAYS} days"
                find "$BACKUP_DIR" -name "mysql_backup_*.sql.gz" -type f -mtime +$${RETENTION_DAYS} -delete

                # List current backups
                echo "Current backups:"
                ls -la "$BACKUP_DIR"/mysql_backup_*.sql.gz 2>/dev/null || echo "No backups found"

                echo "Backup process completed at $(date)"
                EOT
              ]

              env {
                name  = "MYSQL_HOST"
                value = var.mysql_host
              }

              env {
                name  = "MYSQL_PORT"
                value = var.mysql_port
              }

              env {
                name = "MYSQL_USER"
                value_from {
                  secret_key_ref {
                    name = kubernetes_secret.backup_secrets.metadata[0].name
                    key  = "mysql-user"
                  }
                }
              }

              env {
                name = "MYSQL_PASSWORD"
                value_from {
                  secret_key_ref {
                    name = kubernetes_secret.backup_secrets.metadata[0].name
                    key  = "mysql-password"
                  }
                }
              }

              env {
                name  = "RETENTION_DAYS"
                value = tostring(var.mysql_backup_retention_days)
              }

              volume_mount {
                name       = "backup-storage"
                mount_path = "/backup"
              }

              resources {
                requests = {
                  memory = var.backup_memory_request
                  cpu    = var.backup_cpu_request
                }
                limits = {
                  memory = var.backup_memory_limit
                  cpu    = var.backup_cpu_limit
                }
              }
            }

            volume {
              name = "backup-storage"
              persistent_volume_claim {
                claim_name = module.backup_storage_mysql[0].pvc_name
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_secret.backup_secrets,
    module.backup_storage_mysql
  ]
}