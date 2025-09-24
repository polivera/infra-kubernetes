# apps/kavita/terraform/ingress.tf
module "homarr_ingress" {
  source            = "../../../modules/ingress"
  cert_secret       = module.globals.cert_secret_name
  external_name     = "${var.namespace}.${var.namespace}.svc.cluster.local"
  hostname          = local.app_url
  ingress_name      = "${var.namespace}-ingress"
  ingress_namespace = module.globals.ingress_namespace
  port              = var.port

  depends_on = [
    module.homarr_deployment
  ]
}
