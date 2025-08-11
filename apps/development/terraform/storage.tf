# apps/development/terraform/storage.tf

# PostgreSQL Storage
module "postgres_dev_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "postgres-dev"
  namespace  = kubernetes_namespace.development.metadata[0].name
  size       = var.postgres_request_storage
  pool       = "fast"
  force_path = "Development/postgres"
}

# Redis Storage
module "redis_dev_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "redis-dev"
  namespace  = kubernetes_namespace.development.metadata[0].name
  size       = var.redis_request_storage
  pool       = "fast"
  force_path = "Development/redis"
}