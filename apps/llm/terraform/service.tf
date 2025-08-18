# apps/llm/terraform/services.tf
# Ollama Service
module "ollama_service" {
  source      = "../../../modules/services"
  name        = "ollama"
  namespace   = var.namespace
  headless    = true
  port        = var.ollama_port
  target_port = var.ollama_port
}

# WebUI Coding Service
module "webui_coding_service" {
  source      = "../../../modules/services"
  name        = "webui-coding"
  namespace   = var.namespace
  headless    = false
  port        = var.webui_port
  target_port = var.webui_port
}

# WebUI General Service
module "webui_general_service" {
  source      = "../../../modules/services"
  name        = "webui-general"
  namespace   = var.namespace
  headless    = false
  port        = var.webui_port
  target_port = var.webui_port
}
