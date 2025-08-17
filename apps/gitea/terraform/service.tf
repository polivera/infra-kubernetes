# Services
module "gitea_service" {
  source      = "../../../modules/services"
  name        = "gitea"
  namespace   = var.namespace
  headless    = true
  port        = var.http_port
  target_port = var.http_port
}

# SSH Service (LoadBalancer for external Git access)
resource "kubernetes_service" "gitea_ssh" {
  metadata {
    name      = "gitea-ssh"
    namespace = var.namespace
    annotations = {
      "metallb.universe.tf/loadBalancerIPs" = var.ssh_external_ip
    }
  }

  spec {
    type = "LoadBalancer"
    selector = {
      app = "gitea"
    }
    port {
      name        = "ssh"
      port        = 22
      target_port = var.ssh_port
      protocol    = "TCP"
    }
  }
}
