module "mysql_service" {
  source      = "../../../../../modules/services"
  namespace   = var.namespace
  headless    = true
  external    = true
  external_ip = "192.168.0.130"
  port        = var.mysql_external_port
  target_port = var.mysql_port
  app_name    = var.mysql_app_name
  service_name = "mysql-serivce"
}
