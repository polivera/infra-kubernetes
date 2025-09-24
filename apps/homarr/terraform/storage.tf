module "homarr_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${var.namespace}-config"
  namespace  = var.namespace
  size       = var.storage_size
  pool       = "slow"
  force_path = "Homarr/appdata"
}