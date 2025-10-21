# apps/llm/terraform/services.tf
# Ollama Service
module "jellyfin_service" {
  source       = "../../../modules/services"
  namespace    = var.namespace
  headless     = true
  port         = var.port
  target_port  = var.port
  app_name     = var.namespace
  service_name = var.namespace
}

