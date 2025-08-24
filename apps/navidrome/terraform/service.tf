# Service for navidrome
module "navidrome_service" {
  source      = "../../../modules/services"
  name        = "navidrome"
  namespace   = var.namespace
  headless    = false
  port        = var.port
  target_port = var.port
}
