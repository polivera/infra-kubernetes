module "planka_ingress" {
  source = "../../../modules/ingress"

  cert_secret       = module.globals.cert_secret_name
  external_name     = "planka.planka.svc.cluster.local"
  hostname          = local.app_url
  ingress_name      = "planka-ingress"
  ingress_namespace = module.globals.ingress_namespace
  port              = var.port

  depends_on = [
    kubernetes_deployment.planka
  ]
}
