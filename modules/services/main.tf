# Headless service for StatefulSet
resource "kubernetes_service" "this-headless" {
  count = var.headless ? 1 : 0

  metadata {
    name      = "${var.service_name}-headless"
    namespace = var.namespace
  }

  spec {
    cluster_ip = "None"
    selector = {
      app = var.app_name
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
    name      = var.service_name
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.app_name
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
    name      = "${var.service_name}-external"
    namespace = var.namespace
    annotations = {
      "metallb.universe.tf/loadBalancerIPs" = var.external_ip
    }
  }

  spec {
    type = var.external_service_type

    selector = {
      app = var.app_name
    }

    port {
      name        = var.service_name
      port        = var.port
      target_port = var.target_port
      protocol    = var.external_port_protocol
    }

    load_balancer_source_ranges = var.external_allowed_cdir
  }
}