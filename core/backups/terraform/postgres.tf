# apps/backup/terraform/postgres-backup.tf
resource "kubernetes_cron_job_v1" "postgres_backup" {
  count = var.postgres_backup_enabled ? 1 : 0

  metadata {
    name      = "postgres-backup"
    namespace = var.namespace
    labels = {
      app       = "postgres-backup"
      component = "backup"
      database  = "postgres"
    }
  }

  spec {
    schedule                      = var.postgres_backup_schedule
    timezone                      = module.globals.timezone
    successful_jobs_history_limit = 3
    failed_jobs_history_limit     = 3
    concurrency_policy           = "Forbid"

    job_template {
      metadata {
        labels = {
          app       = "postgres-backup"
          component = "backup"
          database  = "postgres"
        }
      }

      spec {
        backoff_limit = 3
        ttl_seconds_after_finished = 86400 # 24 hours

        template {
          metadata {
            labels = {
              app       = "postgres-backup"
              component = "backup"
              database  = "postgres"
            }
          }

          spec {
            restart_policy = "OnFailure"

            container {
              name  = "postgres-backup"
              image = "postgres:17"

              command = ["/bin/bash"]
              args = [
                "-c",
                <<-EOT
set -euo pipefail

# Manually provided list of databases to backup
DATABASES="paperless docmost planka"

# Base backup directory
BACKUP_BASE_DIR="/backup"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

echo "Starting backup process at $(date)"
echo "Databases to backup: $DATABASES"

# Loop through each database
for DATABASE in $DATABASES; do
  echo "----------------------------------------"
  echo "Backing up database: $DATABASE"

  # Create backup with timestamp and database name
  BACKUP_FILE="$BACKUP_BASE_DIR/$${DATABASE}-postgres-$${TIMESTAMP}.sql.gz"

  echo "Starting backup to $BACKUP_FILE"
  pg_dump -h $POSTGRES_HOST -U $POSTGRES_USER $DATABASE | gzip > "$BACKUP_FILE"

  # Verify backup was created and has content
  if [ -s "$BACKUP_FILE" ]; then
    echo "Backup completed successfully: $(ls -lh $BACKUP_FILE)"
  else
    echo "ERROR: Backup file is empty or missing for database: $DATABASE"
    exit 1
  fi

  # Clean up backups older than 30 days for this specific database
  echo "Cleaning up old backups for database: $DATABASE"
  find "$BACKUP_BASE_DIR" -name "$${DATABASE}-postgres-*.sql.gz" -type f -mtime +30 -delete

  # Show remaining backups for this database
  echo "Remaining backups for $DATABASE:"
  ls -la "$BACKUP_BASE_DIR"/$${DATABASE}-postgres-*.sql.gz 2>/dev/null || echo "No backups found for $DATABASE"
done

echo "----------------------------------------"
echo "Backup process completed at $(date)"
echo "All database backups:"
ls -la "$BACKUP_BASE_DIR"/*-postgres-*.sql.gz 2>/dev/null || echo "No backups found"
                EOT
              ]

              env {
                name  = "POSTGRES_HOST"
                value = var.postgres_host
              }

              env {
                name  = "POSTGRES_PORT"
                value = var.postgres_port
              }

              env {
                name = "POSTGRES_USER"
                value_from {
                  secret_key_ref {
                    name = kubernetes_secret.backup_secrets.metadata[0].name
                    key  = "postgres-user"
                  }
                }
              }

              env {
                name = "PGPASSWORD"
                value_from {
                  secret_key_ref {
                    name = kubernetes_secret.backup_secrets.metadata[0].name
                    key  = "postgres-password"
                  }
                }
              }

              env {
                name  = "RETENTION_DAYS"
                value = tostring(var.postgres_backup_retention_days)
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
                claim_name = module.backup_storage_postgres[0].pvc_name
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_secret.backup_secrets,
    module.backup_storage_postgres
  ]
}