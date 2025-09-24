# Ingress
module "vikunja_ingress" {
  source            = "../../../modules/ingress"
  cert_secret       = module.globals.cert_secret_name
  external_name     = "vikunja.vikunja.svc.cluster.local"
  hostname          = local.app_url
  ingress_name      = "vikunja-ingress"
  ingress_namespace = module.globals.ingress_namespace
  port              = var.port

  depends_on = [
    module.vikunja_stateful_set
  ]
}