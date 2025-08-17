# apps/metube/terraform/ingress.tf
locals {
  app_url = "metube.${module.globals.domain}"
}

module "metube_ingress" {
  source            = "../../../modules/ingress"
  cert_secret       = module.globals.cert_secret_name
  external_name     = "metube.metube.svc.cluster.local"
  hostname          = local.app_url
  ingress_name      = "metube-ingress"
  ingress_namespace = module.globals.ingress_namespace
  port              = var.port

  depends_on = [
    kubernetes_deployment.metube
  ]
}