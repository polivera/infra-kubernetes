# apps/audiobookshelf/terraform/ingress.tf
locals {
  app_url = "audiobooks.${module.globals.domain}"
}

module "audiobookshelf_ingress" {
  source            = "../../../modules/ingress"
  cert_secret       = module.globals.cert_secret_name
  external_name     = "audiobookshelf.audiobookshelf.svc.cluster.local"
  hostname          = local.app_url
  ingress_name      = "audiobookshelf-ingress"
  ingress_namespace = module.globals.ingress_namespace
  port              = var.port

  depends_on = [
    kubernetes_stateful_set.audiobookshelf
  ]
}