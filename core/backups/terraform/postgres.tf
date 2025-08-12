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

                # Set variables
                TIMESTAMP=$(date +%Y%m%d_%H%M%S)
                BACKUP_DIR="/backup"

                # Create backup directory
                mkdir -p "$BACKUP_DIR"

                echo "Starting Postgres backup at $(date)"
                echo "Host: $POSTGRES_HOST:$POSTGRES_PORT"
                echo "User: $POSTGRES_USER"

                # Get list of all databases (excluding templates and postgres system dbs)
                DATABASES=$(psql \
                  --host="$POSTGRES_HOST" \
                  --port="$POSTGRES_PORT" \
                  --username="$POSTGRES_USER" \
                  --dbname="postgres" \
                  --tuples-only \
                  --command="SELECT datname FROM pg_database WHERE datistemplate = false AND datname NOT IN ('postgres');" \
                  | sed '/^$/d' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')

                # Always backup the main postgres database
                ALL_DATABASES="postgres"
                if [ -n "$DATABASES" ]; then
                  ALL_DATABASES="postgres $DATABASES"
                fi

                echo "Databases to backup: $ALL_DATABASES"

                BACKUP_COUNT=0
                TOTAL_SIZE=0

                # Backup each database separately
                for db in $ALL_DATABASES; do
                  echo "Backing up database: $db"

                  BACKUP_FILE="$BACKUP_DIR/$${db}_backup_$TIMESTAMP.sql"
                  COMPRESSED_FILE="$BACKUP_FILE.gz"

                  # Create backup for this database
                  pg_dump \
                    --host="$POSTGRES_HOST" \
                    --port="$POSTGRES_PORT" \
                    --username="$POSTGRES_USER" \
                    --dbname="$db" \
                    --verbose \
                    --clean \
                    --if-exists \
                    --create \
                    --format=plain \
                    > "$BACKUP_FILE"

                  # Check if backup was successful
                  if [[ $? -eq 0 && -f "$BACKUP_FILE" && -s "$BACKUP_FILE" ]]; then
                    # Compress backup
                    gzip "$$BACKUP_FILE"

                    if [[ -f "$COMPRESSED_FILE" && -s "$COMPRESSED_FILE" ]]; then
                      FILE_SIZE=$(du -b "$COMPRESSED_FILE" | cut -f1)
                      TOTAL_SIZE=$((TOTAL_SIZE + FILE_SIZE))
                      BACKUP_COUNT=$((BACKUP_COUNT + 1))
                      echo "✓ Backup completed for $db: $COMPRESSED_FILE ($(du -h "$COMPRESSED_FILE" | cut -f1))"
                    else
                      echo "✗ ERROR: Compressed backup file is missing or empty for database: $db"
                      exit 1
                    fi
                  else
                    echo "✗ ERROR: pg_dump failed for database: $db"
                    exit 1
                  fi
                done

                echo "Backup summary:"
                echo "- Databases backed up: $BACKUP_COUNT"
                echo "- Total backup size: $(echo $TOTAL_SIZE | awk '{printf "%.2f MB", $1/1024/1024}')"

                # Cleanup old backups (keep last N days)
                echo "Cleaning up backups older than $${RETENTION_DAYS} days"
                find "$BACKUP_DIR" -name "*_backup_*.sql.gz" -type f -mtime +$${RETENTION_DAYS} -delete

                # List current backups grouped by database
                echo "Current backups by database:"
                for db in $ALL_DATABASES; do
                  echo "Database: $db"
                  ls -la "$BACKUP_DIR"/$${db}_backup_*.sql.gz 2>/dev/null | tail -5 || echo "  No backups found"
                done

                echo "Backup process completed at $$(date)"
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
                name  = "POSTGRES_DB"
                value = var.postgres_database
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