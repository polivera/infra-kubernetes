# Storage for Planka user content (attachments, avatars, etc.)
module "planka_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = kubernetes_namespace.planka.metadata[0].name
  namespace  = kubernetes_namespace.planka.metadata[0].name
  size       = var.request_storage
  pool       = "slow"
  force_path = "Planka"
}
