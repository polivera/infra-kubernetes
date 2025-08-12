# apps/dashy/terraform/storage.tf
# Storage for Dashy config
module "dashy_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = kubernetes_namespace.dashy.metadata[0].name
  namespace  = kubernetes_namespace.dashy.metadata[0].name
  size       = var.request_storage
  pool       = "slow"
  force_path = "Dashy"
}