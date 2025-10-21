# apps/llm/terraform/ingress.tf

# Ingress for General LLM
module "jellyfin-ingres" {
  source            = "../../../modules/ingress"
  cert_secret       = module.globals.cert_secret_name
  external_name     = "jellyfin.jellyfin.svc.cluster.local"
  hostname          = local.general_app_url
  ingress_name      = "jellyfin-ingress"
  ingress_namespace = module.globals.ingress_namespace
  port              = var.port

  depends_on = [
    module.jellyfin_deployment
  ]
}
