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
  proxy_body_size   = "300m"  # Allow up to 100MB file uploads
  proxy_connect_timeout = "600s"          # 10 minutes connection timeout
  proxy_send_timeout    = "600s"          # 10 minutes send timeout
  proxy_read_timeout    = "600s"          # 10 minutes read timeout

  depends_on = [
    kubernetes_deployment.webui_general
  ]
}
