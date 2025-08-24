# Storage for Navidrome data
module "navidrome_data_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.navidrome.metadata[0].name}-data"
  namespace  = var.namespace
  size       = var.data_storage_size
  pool       = "slow"
  force_path = "Navidrome/data"
  depends_on = [kubernetes_namespace.navidrome]
}

# Storage for music library (likely larger)
module "navidrome_music_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.navidrome.metadata[0].name}-music"
  namespace  = var.namespace
  size       = var.music_storage_size
  pool       = "slow"
  force_path = "Media/music"
  depends_on = [kubernetes_namespace.navidrome]
}
