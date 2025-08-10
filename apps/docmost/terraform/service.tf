# Service for Docmost
module "docmost_service" {
  source      = "../../../modules/services"
  name        = "docmost"
  namespace   = var.namespace
  headless    = false
  port        = var.port
  target_port = var.port
}
