# apps/searxng/terraform/ingress.tf
module "searxng_ingress" {
  source            = "../../../modules/ingress"
  cert_secret       = module.globals.cert_secret_name
  external_name     = "searxng.searxng.svc.cluster.local"
  hostname          = local.app_url
  ingress_name      = "searxng-ingress"
  ingress_namespace = module.globals.ingress_namespace
  port              = var.port

  depends_on = [
    kubernetes_stateful_set.searxng
  ]
}