# apps/metube/terraform/service.tf
# Service for Metube
module "metube_service" {
  source      = "../../../modules/services"
  name        = "metube"
  namespace   = var.namespace
  headless    = false
  port        = var.port
  target_port = var.port
}