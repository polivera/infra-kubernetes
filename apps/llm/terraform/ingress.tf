# apps/llm/terraform/ingress.tf

# Ingress for General LLM
module "general_llm_ingress" {
  source            = "../../../modules/ingress"
  cert_secret       = module.globals.cert_secret_name
  external_name     = "webui-general.llm.svc.cluster.local"
  hostname          = local.general_app_url
  ingress_name      = "general-llm-ingress"
  ingress_namespace = module.globals.ingress_namespace
  port              = var.webui_port

  depends_on = [
    kubernetes_deployment.webui_general
  ]
}
