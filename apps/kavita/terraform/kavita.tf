# apps/kavita/terraform/kavita.tf
# Kavita Deployment
resource "kubernetes_deployment" "kavita" {
  metadata {
    name      = "kavita"
    namespace = var.namespace
    labels = {
      app = "kavita"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "kavita"
      }
    }

    template {
      metadata {
        labels = {
          app = "kavita"
        }
      }

      spec {
        container {
          name  = "kavita"
          image = var.image

          env {
            name  = "TZ"
            value = module.globals.timezone
          }

          port {
            container_port = var.port
            name           = "http"
          }

          volume_mount {
            name       = "kavita-config"
            mount_path = "/kavita/config"
          }

          volume_mount {
            name       = "kavita-media"
            mount_path = "/books"
            read_only  = true # Prevent accidental modification of media files
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
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/"
              port = var.port
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
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
          name = "kavita-config"
          persistent_volume_claim {
            claim_name = module.kavita_config_storage.pvc_name
          }
        }

        volume {
          name = "kavita-media"
          persistent_volume_claim {
            claim_name = module.kavita_media_storage.pvc_name
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
    module.kavita_config_storage,
    module.kavita_media_storage
  ]
}

