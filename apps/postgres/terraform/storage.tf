# Use the module for each app's storage
module "postgres_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = kubernetes_namespace.postgres.metadata[0].name
  namespace  = kubernetes_namespace.postgres.metadata[0].name
  size       = var.request_storage
  pool       = "fast"
  force_path = "Databases/postgres"
}

# Storage for PostgreSQL backups
module "postgres_backup_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.postgres.metadata[0].name}-backup"
  namespace  = kubernetes_namespace.postgres.metadata[0].name
  size       = var.backup_storage_size
  pool       = "slow"
  force_path = "Backups/postgres"
}