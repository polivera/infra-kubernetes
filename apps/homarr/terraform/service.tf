# apps/kavita/terraform/service.tf
# Service for Kavita
module "homarr_service" {
  source       = "../../../modules/services"
  namespace    = var.namespace
  headless     = false
  port         = var.port
  target_port  = var.port
  app_name     = var.namespace
  service_name = var.namespace

  depends_on = [
    module.homarr_deployment
  ]
}
