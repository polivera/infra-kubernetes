# apps/redis/terraform/storage.tf
module "redis_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = kubernetes_namespace.redis.metadata[0].name
  namespace  = kubernetes_namespace.redis.metadata[0].name
  size       = var.request_storage
  pool       = "fast"
  force_path = "Databases/redis"
}
