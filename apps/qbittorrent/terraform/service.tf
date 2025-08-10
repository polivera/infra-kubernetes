# apps/qbittorrent/terraform/service.tf
module "qbittorrent_service" {
  source      = "../../../modules/services"
  name        = "qbittorrent"
  namespace   = var.namespace
  headless    = true
  port        = var.web_port
  target_port = var.web_port
}
