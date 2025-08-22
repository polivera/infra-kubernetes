# apps/valkey/terraform/storage.tf
module "valkey_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = kubernetes_namespace.valkey.metadata[0].name
  namespace  = kubernetes_namespace.valkey.metadata[0].name
  size       = var.storage_size
  pool       = "fast"
  force_path = "Databases/valkey"
}

