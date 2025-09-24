# apps/searxng/terraform/service.tf
module "searxng_service" {
  source       = "../../../modules/services"
  namespace    = var.namespace
  headless     = false
  port         = var.port
  target_port  = var.port
  app_name     = var.namespace
  service_name = var.namespace
}
