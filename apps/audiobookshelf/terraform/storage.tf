# apps/audiobookshelf/terraform/storage.tf
# Config storage for AudioBookshelf
module "audiobookshelf_config_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.audiobookshelf.metadata[0].name}-config"
  namespace  = kubernetes_namespace.audiobookshelf.metadata[0].name
  size       = var.config_storage
  pool       = "fast"
  force_path = "AudioBookshelf/config"
}

# Metadata storage for covers, database, etc.
module "audiobookshelf_metadata_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.audiobookshelf.metadata[0].name}-metadata"
  namespace  = kubernetes_namespace.audiobookshelf.metadata[0].name
  size       = var.metadata_storage
  pool       = "fast"
  force_path = "AudioBookshelf/metadata"
}

# Audiobooks storage
module "audiobookshelf_audiobooks_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.audiobookshelf.metadata[0].name}-audiobooks"
  namespace  = kubernetes_namespace.audiobookshelf.metadata[0].name
  size       = var.audiobooks_storage
  pool       = "slow"
  force_path = "Media/audiobooks"
}
