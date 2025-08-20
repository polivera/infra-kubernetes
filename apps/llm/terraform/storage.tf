# apps/llm/terraform/storage.tf
# Storage for Ollama models
module "ollama_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.llm.metadata[0].name}-ollama"
  namespace  = kubernetes_namespace.llm.metadata[0].name
  size       = var.ollama_request_storage
  pool       = "fast"
  force_path = "LLM/ollama"
}

module "webui_general_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "${kubernetes_namespace.llm.metadata[0].name}-webui-general"
  namespace  = kubernetes_namespace.llm.metadata[0].name
  size       = var.webui_data_storage
  pool       = "fast"
  force_path = "LLM/webui-general"
}
