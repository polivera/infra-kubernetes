# apps/kavita/terraform/service.tf
# Service for Kavita
module "heimdall_service" {
  source      = "../../../modules/services"
  name        = "heimdall"
  namespace   = var.namespace
  headless    = false
  port        = var.port
  target_port = var.port
}
