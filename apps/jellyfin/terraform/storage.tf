# apps/llm/terraform/storage.tf
# Storage for Ollama models

module "jellyfin_config_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.jellyfin.metadata[0].name}-config"
  namespace  = kubernetes_namespace.jellyfin.metadata[0].name
  size       = var.config_storage
  pool       = "fast"
  force_path = "Jellyfin/config"
}

module "jellyfin_cache_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.jellyfin.metadata[0].name}-cache"
  namespace  = kubernetes_namespace.jellyfin.metadata[0].name
  size       = var.config_storage
  pool       = "fast"
  force_path = "Jellyfin/config"
}

module "jellyfin_movies_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.jellyfin.metadata[0].name}-movies"
  namespace  = kubernetes_namespace.jellyfin.metadata[0].name
  size       = var.config_storage
  pool       = "slow"
  force_path = "Media/movies"
}

module "jellyfin_youtube_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.jellyfin.metadata[0].name}-youtube"
  namespace  = kubernetes_namespace.jellyfin.metadata[0].name
  size       = var.config_storage
  pool       = "slow"
  force_path = "Media/youtube"
}

module "jellyfin_anime_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.jellyfin.metadata[0].name}-anime"
  namespace  = kubernetes_namespace.jellyfin.metadata[0].name
  size       = var.config_storage
  pool       = "slow"
  force_path = "Media/anime"
}
