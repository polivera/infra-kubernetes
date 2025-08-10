# apps/kavita/terraform/service.tf
# Service for Kavita
module "kavita_service" {
  source      = "../../../modules/services"
  name        = "kavita"
  namespace   = var.namespace
  headless    = false
  port        = var.port
  target_port = var.port
}
