# apps/valkey/terraform/service.tf
module "valkey_service" {
  source      = "../../../modules/services"
  name        = "valkey"
  namespace   = var.namespace
  headless    = true
  port        = var.port
  target_port = var.port
}
