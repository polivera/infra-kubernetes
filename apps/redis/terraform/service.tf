# Service for cluster-wide access
module "redis_service" {
  source      = "../../../modules/services"
  name        = "redis"
  namespace   = var.namespace
  headless    = true
  port        = var.port
  target_port = var.port
}
