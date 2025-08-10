# apps/mysql/terraform/service.tf
module "mysql_service" {
  source      = "../../../modules/services"
  name        = var.namespace
  namespace   = var.namespace
  headless    = true
  external    = true
  external_ip = "192.168.0.122"
  port        = var.mysql_port
  target_port = var.mysql_port
}
