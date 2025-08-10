# apps/mysql/terraform/storage.tf
# Use the module for MySQL storage
module "mysql_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.mysql.metadata[0].name}-mysql"
  namespace  = kubernetes_namespace.mysql.metadata[0].name
  size       = var.mysql_request_storage
  pool       = "fast"
  force_path = "Flipflow/mysql"
}