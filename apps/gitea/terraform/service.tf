# Services
module "gitea_service" {
  source       = "../../../modules/services"
  service_name = "gitea"
  app_name     = var.namespace
  namespace    = var.namespace
  headless     = true
  port         = var.http_port
  target_port  = var.http_port
}

module "gitea_ssh" {
  source                 = "../../../modules/services"
  service_name           = "gitea-ssh"
  app_name               = var.namespace
  namespace              = var.namespace
  port                   = var.ssh_port
  target_port            = var.internal_ssh_port
  external               = true
  external_ip            = var.ssh_external_ip
  external_port_protocol = "TCP"
}

