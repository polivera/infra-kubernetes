# apps/mysql/terraform/storage.tf
# Use the module for MySQL storage
module "mysql_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = kubernetes_namespace.mysql.metadata[0].name
  namespace  = kubernetes_namespace.mysql.metadata[0].name
  size       = var.request_storage
  pool       = "fast"
  force_path = "Databases/mysql"
}