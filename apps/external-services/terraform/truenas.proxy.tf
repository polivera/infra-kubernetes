locals {
  truenas = {
    namespace    = module.globals.ingress_namespace
    service_name = "truenas-app"
    ingress_name = "truenas-app-ingress"
    local_port   = 80
    target_ip    = "192.168.0.11"
    target_port  = 80
    hostname     = "truenas.vicugna.party"
  }
}

resource "kubernetes_service" "external_service" {
  metadata {
    name      = local.truenas.service_name
    namespace = local.truenas.namespace
  }

  spec {
    # No selector = external service
    port {
      name        = "http"
      port        = local.truenas.local_port
      target_port = local.truenas.target_port
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}

# Define the external endpoint
resource "kubernetes_endpoints" "external_service" {
  metadata {
    name      = kubernetes_service.external_service.metadata[0].name
    namespace = kubernetes_service.external_service.metadata[0].namespace
  }

  subset {
    address {
      ip = local.truenas.target_ip
    }

    port {
      name     = "http"
      port     = local.truenas.target_port
      protocol = "TCP"
    }
  }
}

resource "kubernetes_ingress_v1" "external_ingress" {
  metadata {
    name      = local.truenas.ingress_name
    namespace = kubernetes_service.external_service.metadata[0].namespace
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = local.truenas.hostname

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.external_service.metadata[0].name
              port {
                number = local.truenas.local_port
              }
            }
          }
        }
      }
    }
    tls {
      hosts       = [local.opnsense.hostname]
      secret_name = module.globals.cert_secret_name
    }
  }
}
