# Headless service for StatefulSet
resource "kubernetes_service" "this-headless" {
  count = var.headless ? 1 : 0

  metadata {
    name      = "${var.name}-headless"
    namespace = var.namespace
  }

  spec {
    cluster_ip = "None"
    selector = {
      app = var.name
    }

    port {
      port        = var.port
      target_port = var.target_port
    }

    type = var.service_type
  }
}

# Regular service for easy access
resource "kubernetes_service" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.name
    }

    port {
      port        = var.port
      target_port = var.target_port
    }
  }
}

# Make it conditional in external-service.tf
resource "kubernetes_service" "this-external" {
  count = var.external ? 1 : 0

  metadata {
    name      = "${var.name}-external"
    namespace = var.namespace
    annotations = {
      "metallb.universe.tf/loadBalancerIPs" = var.external_ip
    }
  }

  spec {
    type = "LoadBalancer"

    selector = {
      app = "mysql"
    }

    port {
      name        = "mysql"
      port        = var.port
      target_port = var.port
      protocol    = "TCP"
    }

    load_balancer_source_ranges = var.external_allowed_cdir
  }
}