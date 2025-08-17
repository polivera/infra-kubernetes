# Storage for Gitea data
module "gitea_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = kubernetes_namespace.gitea.metadata[0].name
  namespace  = kubernetes_namespace.gitea.metadata[0].name
  size       = var.storage_size
  pool       = "slow"
  force_path = "Gitea"
}