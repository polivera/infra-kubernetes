# Ingress
module "gitea_ingress" {
  source            = "../../../modules/ingress"
  cert_secret       = module.globals.cert_secret_name
  external_name     = "gitea.gitea.svc.cluster.local"
  hostname          = local.app_url
  ingress_name      = "gitea-ingress"
  ingress_namespace = module.globals.ingress_namespace
  port              = var.http_port

  depends_on = [
    kubernetes_stateful_set.gitea
  ]
}