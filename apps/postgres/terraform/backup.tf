# CronJob for automated PostgreSQL backups
resource "kubernetes_cron_job_v1" "postgres_backup" {
  metadata {
    name      = "postgres-backup"
    namespace = var.namespace
    labels = {
      app = "postgres-backup"
    }
  }

  spec {
    schedule = var.backup_schedule

    job_template {
      metadata {
        name = "postgres-backup"
      }

      spec {
        template {
          metadata {
            name = "postgres-backup"
          }

          spec {
            restart_policy = "OnFailure"

            container {
              name  = "postgres-backup"
              image = var.image # Use same postgres image

              env {
                name = "POSTGRES_PASSWORD"
                value_from {
                  secret_key_ref {
                    name = kubernetes_secret.postgres.metadata[0].name
                    key  = "postgres-password"
                  }
                }
              }

              env {
                name = "POSTGRES_USER"
                value_from {
                  secret_key_ref {
                    name = kubernetes_secret.postgres.metadata[0].name
                    key  = "postgres-user"
                  }
                }
              }

              env {
                name = "POSTGRES_DB"
                value_from {
                  config_map_key_ref {
                    name = kubernetes_config_map.postgres.metadata[0].name
                    key  = "POSTGRES_DB"
                  }
                }
              }

              env {
                name  = "TZ"
                value = module.globals.timezone
              }

              env {
                name  = "POSTGRES_HOST"
                value = "postgres-headless.${var.namespace}.svc.cluster.local"
              }

              command = ["/bin/bash", "-c"]
              args = [
                <<-EOF
                set -e

                TIMESTAMP=$(date +%Y%m%d-%H%M%S)
                BACKUP_DIR="/backup/$TIMESTAMP"

                echo "Starting PostgreSQL backup at $(date)"
                echo "Creating backup directory: $BACKUP_DIR"
                mkdir -p "$BACKUP_DIR"

                # Function to backup a database
                backup_database() {
                  local db_name=$1
                  local backup_file="$BACKUP_DIR/$${db_name}_$${TIMESTAMP}.sql.gz"

                  echo "Backing up database: $db_name"

                  if PGPASSWORD="$POSTGRES_PASSWORD" pg_dump -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$db_name" | gzip > "$backup_file"; then
                    if [ -s "$backup_file" ]; then
                      echo "✓ Database $db_name backed up successfully: $(ls -lh $backup_file | awk '{print $5}')"
                    else
                      echo "✗ ERROR: Backup file for $db_name is empty"
                      return 1
                    fi
                  else
                    echo "✗ ERROR: Failed to backup database $db_name"
                    return 1
                  fi
                }

                # Get list of all databases
                echo "Fetching database list from $POSTGRES_HOST..."
                echo 'PGPASSWORD="$POSTGRES_PASSWORD" psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -t -c "SELECT datname FROM pg_database WHERE datistemplate = false;"'
                DATABASES=$(PGPASSWORD="$POSTGRES_PASSWORD" psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -t -c "SELECT datname FROM pg_database WHERE datistemplate = false;" | sed 's/^[ \t]*//;s/[ \t]*$//' | grep -v '^$')

                if [ -z "$DATABASES" ]; then
                  echo "ERROR: No databases found"
                  exit 1
                fi

                echo "Found databases:"
                echo "$DATABASES"
                echo ""

                # Backup all databases
                SUCCESS_COUNT=0
                TOTAL_COUNT=0

                for db in $DATABASES; do
                  if [ -n "$db" ]; then
                    TOTAL_COUNT=$((TOTAL_COUNT + 1))
                    if backup_database "$db"; then
                      SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
                    fi
                  fi
                done

                # Create backup summary
                echo ""
                echo "=== Backup Summary ==="
                echo "Timestamp: $TIMESTAMP"
                echo "Databases backed up: $SUCCESS_COUNT/$TOTAL_COUNT"
                echo "Backup location: $BACKUP_DIR"
                echo "Files created:"
                ls -la "$BACKUP_DIR"

                # Create backup manifest
                cat > "$BACKUP_DIR/backup_info.txt" << INFO
Backup Date: $(date)
PostgreSQL Host: $POSTGRES_HOST
Databases: $SUCCESS_COUNT/$TOTAL_COUNT
Total Size: $(du -sh "$BACKUP_DIR" | cut -f1)
INFO

                # Cleanup old backups (keep last N days)
                RETENTION_DAYS=${var.backup_retention_days}
                echo ""
                echo "Cleaning up backups older than $RETENTION_DAYS days..."
                find /backup -maxdepth 1 -type d -name "20*" -mtime +$RETENTION_DAYS -exec rm -rf {} \; -print

                # Show storage usage
                echo ""
                echo "Storage usage:"
                df -h /backup
                echo ""
                echo "Recent backups:"
                ls -la /backup/ | grep "^d" | tail -5

                if [ "$SUCCESS_COUNT" -eq "$TOTAL_COUNT" ]; then
                  echo ""
                  echo "✓ All backups completed successfully!"
                else
                  echo ""
                  echo "✗ Some backups failed. Check logs above."
                  exit 1
                fi
                EOF
              ]

              volume_mount {
                name       = "backup-storage"
                mount_path = "/backup"
              }

              resources {
                requests = {
                  memory = var.backup_request_memory
                  cpu    = var.backup_request_cpu
                }
                limits = {
                  memory = var.backup_limit_memory
                  cpu    = var.backup_limit_cpu
                }
              }
            }

            volume {
              name = "backup-storage"
              persistent_volume_claim {
                claim_name = module.postgres_backup_storage.pvc_name
              }
            }
          }
        }
      }
    }

    # Keep last 3 successful jobs, 1 failed job
    successful_jobs_history_limit = 3
    failed_jobs_history_limit     = 1
    concurrency_policy            = "Forbid"
    starting_deadline_seconds     = 300
  }

  depends_on = [
    module.postgres_backup_storage,
    kubernetes_secret.postgres,
    kubernetes_config_map.postgres
  ]
}
