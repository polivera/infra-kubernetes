# apps/llm/terraform/services.tf
# Ollama Service
module "jellyfin_service" {
  source      = "../../../modules/services"
  name        = "jellyfin"
  namespace   = var.namespace
  headless    = true
  port        = var.port
  target_port = var.port
}

