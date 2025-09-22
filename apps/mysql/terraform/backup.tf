# Cron job module

module "mysql_cron_job" {
  source    = "../../../modules/cronjob"
  app_name  = var.namespace
  namespace = var.namespace
  image     = var.namespace
  command   = ["/bin/bash"]
  schedule = "19 21 * * *"

  envs = {
    MYSQL_HOST = {
      value = "mysql.mysql.svc.cluster.local"
    },
    DATABASE_NAMES = {
      value = "gitea,vikunja"
    }
  }
  env_secrets = {
    MYSQL_ROOT_PASSWORD = {
      secret_name = kubernetes_secret.mysql.metadata[0].name
      secret_key  = "mysql-root-password"
    }
  }
  arguments = [
    "-c",
    <<-EOT
    echo 'Starting backup at $$(date)'

    # Read comma-separated database names from env variable
    IFS=',' read -ra DB_ARRAY <<< "$$DATABASE_NAMES"

    # Loop through each database and create individual backups
    for db in "$${DB_ARRAY[@]}"; do
      # Trim whitespace from database name
      db=$$(echo "$$db" | xargs)

      if [ -n "$$db" ]; then
        echo "Backing up database: $$db"
        mysqldump -h mysql -u root -p$$MYSQL_ROOT_PASSWORD --single-transaction --routines --triggers "$$db" > "/backups/backup-$$db-$$(date +%Y%m%d-%H%M%S).sql"
        echo "Backup completed for: $$db"
      fi
    done

    echo 'All backups completed'

    # Clean old backups (keep last 7 days)
    find /backups -name 'backup-*.sql' -mtime +7 -delete
    EOT
  ]
  mounts = [
    {
      name       = "mysql-backup"
      mount_path = "/backups"
      read_only  = false
    }
  ]
  claims = [
    {
      name       = "mysql-backup"
      claim_name = module.mysql_backup.pvc_name
    }
  ]

  depends_on = [module.mysql_backup]
}
