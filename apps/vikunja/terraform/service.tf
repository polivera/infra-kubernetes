# Services
module "vikunja_service" {
  source       = "../../../modules/services"
  service_name = var.namespace
  app_name     = var.namespace
  namespace    = var.namespace
  headless     = true
  port         = var.port
  target_port  = var.port

  depends_on = [
    module.vikunja_stateful_set
  ]
}