# apps/kavita/terraform/storage.tf
# Config storage for Kavita
module "kavita_config_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.kavita.metadata[0].name}-config"
  namespace  = kubernetes_namespace.kavita.metadata[0].name
  size       = var.config_storage
  pool       = "slow"
  force_path = "Kavita/config"
}

# Media storage for Kavita library
module "kavita_media_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.kavita.metadata[0].name}-books"
  namespace  = kubernetes_namespace.kavita.metadata[0].name
  size       = var.media_storage
  pool       = "slow"
  force_path = "Media/books"
}
