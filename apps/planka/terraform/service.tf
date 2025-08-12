# Service for Planka
module "planka_service" {
  source      = "../../../modules/services"
  name        = "planka"
  namespace   = var.namespace
  headless    = false
  port        = var.port
  target_port = var.port
}