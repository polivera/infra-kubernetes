# apps/dashy/terraform/service.tf
module "dashy_service" {
  source      = "../../../modules/services"
  name        = "dashy"
  namespace   = var.namespace
  headless    = false
  port        = var.port
  target_port = var.port
}