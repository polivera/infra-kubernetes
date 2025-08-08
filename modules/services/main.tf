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
