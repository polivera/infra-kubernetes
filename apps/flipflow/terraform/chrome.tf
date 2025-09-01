# Chrome Headless Deployment
resource "kubernetes_deployment" "chrome" {
  metadata {
    name      = "chrome-headless"
    namespace = var.namespace
    labels = {
      app = "chrome-headless"
    }
  }

  spec {
    replicas = var.chrome_replicas

    selector {
      match_labels = {
        app = "chrome-headless"
      }
    }

    template {
      metadata {
        labels = {
          app = "chrome-headless"
        }
      }

      spec {
        container {
          name  = "chrome"
          image = var.chrome_image

          args = [
            "--no-sandbox",
            "--headless=new",
            "--disable-gpu",
            "--disable-software-rasterizer",
            "--disable-dev-shm-usage",
            "--disable-extensions",
            "--disable-plugins",
            "--disable-default-apps",
            "--disable-background-timer-throttling",
            "--disable-backgrounding-occluded-windows",
            "--disable-renderer-backgrounding",
            "--disable-features=TranslateUI,VizDisplayCompositor",
            "--remote-debugging-address=0.0.0.0",
            "--remote-debugging-port=9222",
            "--disable-web-security",
            "--no-first-run"
          ]

          port {
            container_port = var.chrome_port
            name           = "devtools"
            protocol       = "TCP"
          }

          resources {
            requests = {
              memory = var.chrome_request_memory
              cpu    = var.chrome_request_cpu
            }
            limits = {
              memory = var.chrome_limit_memory
              cpu    = var.chrome_limit_cpu
            }
          }

          security_context {
            run_as_user                = 1000
            run_as_group               = 1000
            run_as_non_root            = true
            allow_privilege_escalation = false
          }

          startup_probe {
            tcp_socket {
              port = var.chrome_port
            }
            initial_delay_seconds = 10
            period_seconds        = 5
            failure_threshold     = 30
          }

          readiness_probe {
            tcp_socket {
              port = var.chrome_port
            }
            initial_delay_seconds = 5
            period_seconds        = 5
            failure_threshold     = 3
          }

          liveness_probe {
            tcp_socket {
              port = var.chrome_port
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            failure_threshold     = 3
          }
        }

        security_context {
          fs_group = 1000
        }
      }
    }
  }
}
