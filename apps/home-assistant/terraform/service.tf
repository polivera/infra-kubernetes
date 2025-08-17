module "homeassistant_service" {
  source      = "../../../modules/services"
  name        = "homeassistant"
  namespace   = var.namespace
  headless    = true
  port        = var.port
  target_port = var.port
}
