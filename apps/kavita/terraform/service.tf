# apps/kavita/terraform/service.tf
# Service for Kavita
module "kavita_service" {
  source      = "../../../modules/services"
  name        = "kavita"
  namespace   = var.namespace
  external    = true
  external_ip = "192.168.0.130"
  headless    = false
  port        = var.port
  target_port = var.port
}
