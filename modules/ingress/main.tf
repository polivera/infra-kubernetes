# ExternalName service in the ingress namespace (e.g., default)
resource "kubernetes_service" "proxy" {
  metadata {
    name      = "${var.ingress_name}-proxy"
    namespace = var.ingress_namespace
  }

  spec {
    type          = "ExternalName"
    external_name = var.external_name

    port {
      port        = var.port
      target_port = var.port
      protocol    = "TCP"
    }
  }
}

resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name      = var.ingress_name
    namespace = var.ingress_namespace
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect"          = var.ssl_redirect
      "nginx.ingress.kubernetes.io/proxy-body-size"       = var.proxy_body_size
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = var.proxy_connect_timeout
      "nginx.ingress.kubernetes.io/proxy-send-timeout"    = var.proxy_send_timeout
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = var.proxy_read_timeout
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = var.hostname

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.proxy.metadata[0].name
              port {
                number = var.port
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [var.hostname]
      secret_name = var.cert_secret
    }
  }
}
