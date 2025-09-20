# Docmost Deployment
resource "kubernetes_deployment" "docmost" {
  metadata {
    name      = "docmost"
    namespace = var.namespace
    labels = {
      app = "docmost"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "docmost"
      }
    }

    template {
      metadata {
        labels = {
          app = "docmost"
        }
      }

      spec {
        container {
          name  = "docmost"
          image = var.image

          env {
            name = "APP_URL"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.docmost.metadata[0].name
                key  = "APP_URL"
              }
            }
          }

          env {
            name = "APP_SECRET"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.docmost.metadata[0].name
                key  = "app-secret"
              }
            }
          }

          env {
            name = "DATABASE_URL"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.docmost.metadata[0].name
                key  = "database-url"
              }
            }
          }

          env {
            name = "REDIS_URL"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.docmost.metadata[0].name
                key  = "redis-url"
              }
            }
          }

          env {
            name = "MAIL_DRIVER"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.docmost.metadata[0].name
                key  = "MAIL_DRIVER"
              }
            }
          }

          env {
            name = "MAIL_HOST"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.docmost.metadata[0].name
                key  = "MAIL_HOST"
              }
            }
          }

          env {
            name = "MAIL_PORT"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.docmost.metadata[0].name
                key  = "MAIL_PORT"
              }
            }
          }

          env {
            name = "MAIL_USERNAME"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.docmost.metadata[0].name
                key  = "mail-user"
              }
            }
          }

          env {
            name = "MAIL_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.docmost.metadata[0].name
                key  = "mail-password"
              }
            }
          }

          env {
            name = "MAIL_FROM_ADDRESS"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.docmost.metadata[0].name
                key  = "MAIL_FROM_ADDRESS"
              }
            }
          }

          env {
            name = "MAIL_FROM_NAME"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.docmost.metadata[0].name
                key  = "MAIL_FROM_NAME"
              }
            }
          }

          port {
            container_port = var.port
            name           = "http"
          }

          volume_mount {
            name       = "docmost-uploads"
            mount_path = "/app/data/storage"
          }

          resources {
            requests = {
              memory = var.request_memory
              cpu    = var.request_cpu
            }
            limits = {
              memory = var.limit_memory
              cpu    = var.limit_cpu
            }
          }

          liveness_probe {
            http_get {
              path = "/api/health"
              port = var.port
            }
            initial_delay_seconds = 60
            period_seconds        = 30
            timeout_seconds       = 10
          }

          readiness_probe {
            http_get {
              path = "/api/health"
              port = var.port
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
          }
        }

        volume {
          name = "docmost-uploads"
          persistent_volume_claim {
            claim_name = module.docmost_storage.pvc_name
          }
        }
      }
    }
  }

  depends_on = [
    module.docmost_storage,
    kubernetes_config_map.docmost,
    kubernetes_secret.docmost
  ]
}
