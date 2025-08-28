# apps/mysql/terraform/storage.tf
# Use the module for MySQL storage
module "mysql_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.flipflow.metadata[0].name}-mysql"
  namespace  = kubernetes_namespace.flipflow.metadata[0].name
  size       = var.mysql_request_storage
  pool       = "fast"
  force_path = "Flipflow/mysql"
}

module "postgres_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "druid-postgres"
  namespace  = kubernetes_namespace.flipflow.metadata[0].name
  size       = var.postgres_storage_size
  pool       = "fast"
  force_path = "Flipflow/druid/postgres"
}

module "druid_shared_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "druid-shared"
  namespace  = kubernetes_namespace.flipflow.metadata[0].name
  size       = "30Gi"
  pool       = "fast"
  force_path = "Flipflow/druid/shared"
}

module "druid_historical_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "druid-historical"
  namespace  = kubernetes_namespace.flipflow.metadata[0].name
  size       = var.druid_historical_storage_size
  pool       = "fast"
  force_path = "Flipflow/druid/historical"
}

module "druid_middlemanager_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "druid-middlemanager"
  namespace  = kubernetes_namespace.flipflow.metadata[0].name
  size       = var.druid_middlemanager_storage_size
  pool       = "fast"
  force_path = "Flipflow/druid/middlemanager"
}