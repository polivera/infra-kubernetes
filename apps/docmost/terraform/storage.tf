# Storage for Docmost uploads
module "docmost_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = kubernetes_namespace.docmost.metadata[0].name
  namespace  = kubernetes_namespace.docmost.metadata[0].name
  size       = var.request_storage
  pool       = "slow"
  force_path = "Docmost"
}
