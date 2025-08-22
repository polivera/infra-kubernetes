# apps/searxng/terraform/service.tf
module "searxng_service" {
  source      = "../../../modules/services"
  name        = "searxng"
  namespace   = var.namespace
  headless    = false
  port        = var.port
  target_port = var.port
}
