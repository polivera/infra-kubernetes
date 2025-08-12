# apps/dashy/terraform/ingress.tf
locals {
  app_url = "home.${module.globals.domain}"
}

module "dashy_ingress" {
  source            = "../../../modules/ingress"
  cert_secret       = module.globals.cert_secret_name
  external_name     = "dashy.dashy.svc.cluster.local"
  hostname          = local.app_url
  ingress_name      = "dashy-ingress"
  ingress_namespace = module.globals.ingress_namespace
  port              = var.port

  depends_on = [
    kubernetes_deployment.dashy
  ]
}