# Paperless Deployment
resource "kubernetes_deployment" "paperless" {
  metadata {
    name      = "paperless"
    namespace = var.namespace
    labels = {
      app = "paperless"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "paperless"
      }
    }

    template {
      metadata {
        labels = {
          app = "paperless"
        }
      }

      spec {
        # Init container to run migrations
        init_container {
          name  = "paperless-migrate"
          image = var.image

          command = ["python", "manage.py", "migrate"]

          env {
            name = "PAPERLESS_SECRET_KEY"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.paperless.metadata[0].name
                key  = "secret-key"
              }
            }
          }

          env {
            name  = "PAPERLESS_DBENGINE"
            value = "postgresql"
          }

          env {
            name = "PAPERLESS_DBHOST"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.paperless.metadata[0].name
                key  = "database-host"
              }
            }
          }

          env {
            name = "PAPERLESS_DBNAME"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.paperless.metadata[0].name
                key  = "database-name"
              }
            }
          }

          env {
            name = "PAPERLESS_DBUSER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.paperless.metadata[0].name
                key  = "database-user"
              }
            }
          }

          env {
            name = "PAPERLESS_DBPASS"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.paperless.metadata[0].name
                key  = "database-pass"
              }
            }
          }

          env {
            name = "PAPERLESS_REDIS"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.paperless.metadata[0].name
                key  = "redis-url"
              }
            }
          }

          volume_mount {
            name       = "paperless-data"
            mount_path = "/usr/src/paperless/data"
          }

          volume_mount {
            name       = "paperless-media"
            mount_path = "/usr/src/paperless/media"
          }
        }

        container {
          name  = "paperless"
          image = var.image

          # Core environment variables from secrets
          env {
            name = "PAPERLESS_SECRET_KEY"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.paperless.metadata[0].name
                key  = "secret-key"
              }
            }
          }

          env {
            name = "PAPERLESS_ADMIN_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.paperless.metadata[0].name
                key  = "admin-user"
              }
            }
          }

          env {
            name = "PAPERLESS_ADMIN_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.paperless.metadata[0].name
                key  = "admin-password"
              }
            }
          }

          env {
            name = "PAPERLESS_ADMIN_MAIL"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.paperless.metadata[0].name
                key  = "admin-mail"
              }
            }
          }

          # Database configuration
          env {
            name  = "PAPERLESS_DBENGINE"
            value = "postgresql"
          }

          env {
            name = "PAPERLESS_DBHOST"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.paperless.metadata[0].name
                key  = "database-host"
              }
            }
          }

          env {
            name = "PAPERLESS_DBNAME"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.paperless.metadata[0].name
                key  = "database-name"
              }
            }
          }

          env {
            name = "PAPERLESS_DBUSER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.paperless.metadata[0].name
                key  = "database-user"
              }
            }
          }

          env {
            name = "PAPERLESS_DBPASS"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.paperless.metadata[0].name
                key  = "database-pass"
              }
            }
          }

          # Redis configuration
          env {
            name = "PAPERLESS_REDIS"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.paperless.metadata[0].name
                key  = "redis-url"
              }
            }
          }

          # Load configuration from ConfigMap
          dynamic "env" {
            for_each = kubernetes_config_map.paperless.data
            content {
              name  = env.key
              value = env.value
            }
          }

          port {
            container_port = var.port
            name           = "http"
          }

          volume_mount {
            name       = "paperless-data"
            mount_path = "/usr/src/paperless/data"
          }

          volume_mount {
            name       = "paperless-media"
            mount_path = "/usr/src/paperless/media"
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
              path = "/api/"
              port = var.port
            }
            initial_delay_seconds = 60
            period_seconds        = 30
            timeout_seconds       = 10
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/api/"
              port = var.port
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          startup_probe {
            http_get {
              path = "/api/"
              port = var.port
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 60
          }
        }

        volume {
          name = "paperless-data"
          persistent_volume_claim {
            claim_name = module.paperless_data_storage.pvc_name
          }
        }

        volume {
          name = "paperless-media"
          persistent_volume_claim {
            claim_name = module.paperless_media_storage.pvc_name
          }
        }

        # Security context
        security_context {
          fs_group = 1000
        }
      }
    }
  }

  depends_on = [
    module.paperless_data_storage,
    module.paperless_media_storage,
    kubernetes_config_map.paperless,
    kubernetes_secret.paperless
  ]
}