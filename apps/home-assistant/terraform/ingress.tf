# apps/homeassistant/terraform/ingress.tf
locals {
  app_url = "home-assistant.${module.globals.domain}"
}

module "homeassistant_ingress" {
  source            = "../../../modules/ingress"
  cert_secret       = module.globals.cert_secret_name
  external_name     = "homeassistant.homeassistant.svc.cluster.local"
  hostname          = local.app_url
  ingress_name      = "homeassistant-ingress"
  ingress_namespace = module.globals.ingress_namespace
  port              = var.port

  depends_on = [
    kubernetes_stateful_set.homeassistant
  ]
}