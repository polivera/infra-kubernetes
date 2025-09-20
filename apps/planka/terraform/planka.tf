resource "kubernetes_deployment" "planka" {
  metadata {
    name      = "planka"
    namespace = var.namespace
    labels = {
      app = "planka"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "planka"
      }
    }

    template {
      metadata {
        labels = {
          app = "planka"
        }
      }

      spec {
        container {
          name  = "planka"
          image = var.image

          env_from {
            config_map_ref {
              name = kubernetes_config_map.planka.metadata[0].name
            }
          }

          env {
            name = "DATABASE_URL"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.planka.metadata[0].name
                key  = "database-url"
              }
            }
          }

          env {
            name = "SECRET_KEY"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.planka.metadata[0].name
                key  = "secret-key"
              }
            }
          }

          env {
            name = "DEFAULT_ADMIN_EMAIL"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.planka.metadata[0].name
                key  = "default-admin-email"
              }
            }
          }

          env {
            name = "DEFAULT_ADMIN_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.planka.metadata[0].name
                key  = "default-admin-password"
              }
            }
          }

          env {
            name = "DEFAULT_ADMIN_NAME"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.planka.metadata[0].name
                key  = "default-admin-name"
              }
            }
          }

          env {
            name = "DEFAULT_ADMIN_USERNAME"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.planka.metadata[0].name
                key  = "default-admin-username"
              }
            }
          }

          port {
            container_port = var.port
            name           = "http"
          }

          volume_mount {
            name       = "planka-data"
            mount_path = "/app/public/user-content"
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
              path = "/"
              port = var.port
            }
            initial_delay_seconds = 60
            period_seconds        = 30
            timeout_seconds       = 10
          }

          readiness_probe {
            http_get {
              path = "/"
              port = var.port
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
          }

          startup_probe {
            http_get {
              path = "/"
              port = var.port
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 30
          }
        }

        volume {
          name = "planka-data"
          persistent_volume_claim {
            claim_name = module.planka_storage.pvc_name
          }
        }

        # Security context for file permissions
        security_context {
          fs_group = 1000
        }
      }
    }
  }

  depends_on = [
    module.planka_storage,
    kubernetes_config_map.planka,
    kubernetes_secret.planka
  ]
}