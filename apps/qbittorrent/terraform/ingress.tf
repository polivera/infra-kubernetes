# apps/qbittorrent/terraform/ingress.tf
locals {
  app_url = "torrent.${module.globals.domain}"
}

module "qbittorrent_ingress" {
  source            = "../../../modules/ingress"
  cert_secret       = module.globals.cert_secret_name
  external_name     = "qbittorrent.qbittorrent.svc.cluster.local"
  hostname          = local.app_url
  ingress_name      = "qbittorrent-ingress"
  ingress_namespace = module.globals.ingress_namespace
  port              = var.web_port

  depends_on = [
    kubernetes_stateful_set.qbittorrent
  ]
}
