# apps/searxng/terraform/storage.tf
# Config storage - needs unique PV name
module "searxng_config_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.searxng.metadata[0].name}-config"
  namespace  = kubernetes_namespace.searxng.metadata[0].name
  size       = var.config_storage
  pool       = "fast"
  force_path = "SearXNG/config"
}

# Downloads storage - needs unique PV name
module "searxng_cache_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.searxng.metadata[0].name}-cache"
  namespace  = kubernetes_namespace.searxng.metadata[0].name
  size       = var.cache_storage
  pool       = "fast"
  force_path = "SearXNG/cache"
}
