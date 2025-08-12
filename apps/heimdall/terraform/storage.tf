module "heimdall_config_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.heimdall.metadata[0].name}-config"
  namespace  = kubernetes_namespace.heimdall.metadata[0].name
  size       = var.storage_size
  pool       = "slow"
  force_path = "Heimdall"
}