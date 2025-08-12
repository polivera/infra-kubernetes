# apps/backup/terraform/storage.tf
# Storage for backup files
module "backup_storage_postgres" {
  count      = var.postgres_backup_enabled ? 1 : 0
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.backup.metadata[0].name}-postgres"
  namespace  = kubernetes_namespace.backup.metadata[0].name
  size       = var.backup_storage_size
  pool       = "slow"
  force_path = "Backups/postgres"
}

module "backup_storage_mysql" {
  count      = var.mysql_backup_enabled ? 1 : 0
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.backup.metadata[0].name}-mysql"
  namespace  = kubernetes_namespace.backup.metadata[0].name
  size       = var.backup_storage_size
  pool       = "slow"
  force_path = "Backups/mysql"
}
