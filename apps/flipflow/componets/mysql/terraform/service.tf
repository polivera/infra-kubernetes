module "mysql_service" {
  source      = "../../../../../modules/services"
  name        = "mysql"
  namespace   = var.namespace
  headless    = true
  external    = true
  external_ip = "192.168.0.140"
  port        = var.mysql_external_port
  target_port = var.mysql_port
}
