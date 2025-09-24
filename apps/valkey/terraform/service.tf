# apps/valkey/terraform/service.tf
module "valley_service" {
  source       = "../../../modules/services"
  app_name     = var.namespace
  service_name = var.namespace
  namespace    = var.namespace
  headless     = true
  port         = var.port
  target_port  = var.port
}
