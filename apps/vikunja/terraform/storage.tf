# Storage for Gitea data
module "vikunja_storage_files" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = var.namespace
  namespace  = var.namespace
  size       = var.storage_size
  pool       = "slow"
  force_path = "Vikunja/files"
}