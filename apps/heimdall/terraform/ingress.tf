# apps/kavita/terraform/ingress.tf
locals {
  app_url = "home.${module.globals.domain}"
}

module "kavita_ingress" {
  source            = "../../../modules/ingress"
  cert_secret       = module.globals.cert_secret_name
  external_name     = "heimdall.heimdall.svc.cluster.local"
  hostname          = local.app_url
  ingress_name      = "heimdall-ingress"
  ingress_namespace = module.globals.ingress_namespace
  port              = var.port

  depends_on = [
    kubernetes_deployment.heimdall
  ]
}
