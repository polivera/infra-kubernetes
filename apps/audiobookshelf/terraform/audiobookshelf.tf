# apps/audiobookshelf/terraform/audiobookshelf.tf
# AudioBookshelf StatefulSet
resource "kubernetes_stateful_set" "audiobookshelf" {
  metadata {
    name      = "audiobookshelf"
    namespace = var.namespace
    labels = {
      app = "audiobookshelf"
    }
  }

  spec {
    service_name = "audiobookshelf-headless"
    replicas     = var.replicas

    selector {
      match_labels = {
        app = "audiobookshelf"
      }
    }

    template {
      metadata {
        labels = {
          app = "audiobookshelf"
        }
      }

      spec {
        dns_config {
          nameservers = module.globals.dns_nameservers
          searches    = module.globals.dns_searches
          option {
            name  = "ndots"
            value = "1"
          }
          option {
            name = "edns0"
          }
        }
        container {
          name  = "audiobookshelf"
          image = var.image

          env {
            name  = "TZ"
            value = module.globals.timezone
          }

          env {
            name  = "AUDIOBOOKSHELF_UID"
            value = "1000"
          }

          env {
            name  = "AUDIOBOOKSHELF_GID"
            value = "1000"
          }

          port {
            container_port = var.port
            name           = "http"
          }

          volume_mount {
            name       = "audiobookshelf-config"
            mount_path = "/config"
          }

          volume_mount {
            name       = "audiobookshelf-metadata"
            mount_path = "/metadata"
          }

          volume_mount {
            name       = "audiobookshelf-audiobooks"
            mount_path = "/audiobooks"
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
              path = "/healthcheck"
              port = var.port
            }
            initial_delay_seconds = 60
            period_seconds        = 30
            timeout_seconds       = 10
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/healthcheck"
              port = var.port
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          startup_probe {
            http_get {
              path = "/healthcheck"
              port = var.port
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 30
          }
        }

        volume {
          name = "audiobookshelf-config"
          persistent_volume_claim {
            claim_name = module.audiobookshelf_config_storage.pvc_name
          }
        }

        volume {
          name = "audiobookshelf-metadata"
          persistent_volume_claim {
            claim_name = module.audiobookshelf_metadata_storage.pvc_name
          }
        }

        volume {
          name = "audiobookshelf-audiobooks"
          persistent_volume_claim {
            claim_name = module.audiobookshelf_audiobooks_storage.pvc_name
          }
        }

        # Security context for proper file permissions
        security_context {
          fs_group = 1000
        }
      }
    }
  }

  depends_on = [
    module.audiobookshelf_config_storage,
    module.audiobookshelf_metadata_storage,
    module.audiobookshelf_audiobooks_storage,
  ]
}