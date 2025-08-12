# Media storage for documents
module "paperless_media_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.paperless.metadata[0].name}-media"
  namespace  = kubernetes_namespace.paperless.metadata[0].name
  size       = var.media_storage
  pool       = "slow"
  force_path = "Paperless/media"
}

# Data storage for application data, search index, etc.
module "paperless_data_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.paperless.metadata[0].name}-data"
  namespace  = kubernetes_namespace.paperless.metadata[0].name
  size       = var.data_storage
  pool       = "fast"
  force_path = "Paperless/data"
}