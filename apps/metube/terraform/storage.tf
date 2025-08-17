# apps/metube/terraform/storage.tf
# Downloads storage for Metube
module "metube_downloads_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.metube.metadata[0].name}-downloads"
  namespace  = kubernetes_namespace.metube.metadata[0].name
  size       = var.downloads_storage
  pool       = "slow"
  force_path = "MeTube/downloads"
}