# apps/kavita/terraform/ingress.tf
locals {
  app_url = "books.${module.globals.domain}"
}

module "kavita_ingress" {
  source            = "../../../modules/ingress"
  cert_secret       = module.globals.cert_secret_name
  external_name     = "kavita.kavita.svc.cluster.local"
  hostname          = local.app_url
  ingress_name      = "kavita-ingress"
  ingress_namespace = module.globals.ingress_namespace
  port              = var.port

  depends_on = [
    kubernetes_deployment.kavita
  ]
}
