# apps/homeassistant/terraform/storage.tf
# Storage for Home Assistant config and data
module "homeassistant_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = kubernetes_namespace.homeassistant.metadata[0].name
  namespace  = kubernetes_namespace.homeassistant.metadata[0].name
  size       = var.config_storage
  pool       = var.storage_pool  # Default: slow storage
  force_path = "HomeAssistant/config"
}
