# Services
module "gitea_service" {
  source      = "../../../modules/services"
  name        = "gitea"
  namespace   = var.namespace
  headless    = true
  port        = var.http_port
  target_port = var.http_port
}

module "gitea_ssh" {
  source                 = "../../../modules/services"
  name                   = "gitea-ssh"
  namespace              = var.namespace
  headless               = true
  port                   = var.ssh_port
  target_port            = var.ssh_port
  external               = true
  external_ip            = var.ssh_external_ip
  external_port_protocol = "TCP"
}

