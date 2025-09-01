# apps/mysql/terraform/service.tf
module "mysql_service" {
  source      = "../../../modules/services"
  name        = "mysql"
  namespace   = var.namespace
  headless    = true
  external    = true
  external_ip = "192.168.0.140"
  port        = var.mysql_port
  target_port = var.mysql_port
}


module "chrome_service" {
  source      = "../../../modules/services"
  name        = "chrome"
  namespace   = var.namespace
  headless    = true
  external    = true
  external_ip = "192.168.0.141"
  port        = var.chrome_port
  target_port = var.chrome_port
}
