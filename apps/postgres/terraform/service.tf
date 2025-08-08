module "postgres_service" {
  source = "../../../modules/services"
  name   = var.namespace
  namespace = var.namespace
  headless = true
  port = var.port
  target_port = var.port
}
