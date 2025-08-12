# Service for Paperless
module "paperless_service" {
  source      = "../../../modules/services"
  name        = "paperless"
  namespace   = var.namespace
  headless    = false
  port        = var.port
  target_port = var.port
}