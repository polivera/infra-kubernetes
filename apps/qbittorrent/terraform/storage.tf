# apps/qbittorrent/terraform/storage.tf
# Config storage - needs unique PV name
module "qbittorrent_config_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.qbittorrent.metadata[0].name}-config"
  namespace  = kubernetes_namespace.qbittorrent.metadata[0].name
  size       = var.config_storage
  pool       = "slow"
  force_path = "QBittorrent/config"
}

# Downloads storage - needs unique PV name
module "qbittorrent_downloads_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.qbittorrent.metadata[0].name}-downloads"
  namespace  = kubernetes_namespace.qbittorrent.metadata[0].name
  size       = var.downloads_storage
  pool       = "slow"
  force_path = "QBittorrent/downloads"
}
