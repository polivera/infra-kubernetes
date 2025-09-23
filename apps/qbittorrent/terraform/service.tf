# apps/qbittorrent/terraform/service.tf
module "qbittorrent_service" {
  source       = "../../../modules/services"
  service_name = var.namespace
  app_name     = var.namespace
  namespace    = var.namespace
  headless     = true
  port         = var.web_port
  target_port  = var.web_port
}
