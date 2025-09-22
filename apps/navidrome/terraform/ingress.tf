# apps/navidrome/terraform/ingress.tf
module "navidrome_ingress" {
  source = "../../../modules/ingress"

  cert_secret       = module.globals.cert_secret_name
  external_name     = "navidrome.navidrome.svc.cluster.local"
  hostname          = local.app_url
  ingress_name      = "navidrome-ingress"
  ingress_namespace = module.globals.ingress_namespace
  port              = var.port

  depends_on = [
    module.navidrome_deployment
  ]
}

