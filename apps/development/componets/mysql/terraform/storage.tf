module "mysql_storage" {
  source     = "../../../../../modules/static-nfs-volume"
  app_name   = "${data.kubernetes_namespace.mysql.metadata[0].name}-mysql"
  namespace  = data.kubernetes_namespace.mysql.metadata[0].name
  size       = var.mysql_request_storage
  pool       = "fast"
  force_path = "Development/mysql"
}
