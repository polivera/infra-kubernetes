set -e

# Create backup with timestamp
BACKUP_FILE="/backup/paperless-postgres-$(date +%Y%m%d-%H%M%S).sql.gz"

echo "Starting backup to $BACKUP_FILE"
pg_dump -h postgres -U $POSTGRES_USER $POSTGRES_DB | gzip > "$BACKUP_FILE"

# Verify backup was created and has content
if [ -s "$BACKUP_FILE" ]; then
  echo "Backup completed successfully: $(ls -lh $BACKUP_FILE)"
else
  echo "ERROR: Backup file is empty or missing"
  exit 1
fi

# Clean up backups older than 30 days
find /backup -name "paperless-postgres-*.sql.gz" -type f -mtime +30 -delete

# Show remaining backups
echo "Remaining backups:"
ls -la /backup/paperless-postgres-*.sql.gz 2>/dev/null || echo "No backups found"