# apps/development/terraform/services.tf

# PostgreSQL Services
module "postgres_dev_service" {
  source      = "../../../modules/services"
  name        = "postgres-dev"
  namespace   = var.namespace
  headless    = true
  external    = true
  external_ip = var.postgres_external_ip
  port        = var.postgres_port
  target_port = var.postgres_port

  depends_on = [kubernetes_stateful_set.postgres_dev]
}

# Redis Services
module "redis_dev_service" {
  source      = "../../../modules/services"
  name        = "redis-dev"
  namespace   = var.namespace
  headless    = true
  external    = true
  external_ip = var.redis_external_ip
  port        = var.redis_port
  target_port = var.redis_port

  depends_on = [kubernetes_stateful_set.redis_dev]
}