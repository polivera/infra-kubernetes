# apps/metube/terraform/metube.tf
# Metube Deployment
resource "kubernetes_deployment" "metube" {
  metadata {
    name      = "metube"
    namespace = var.namespace
    labels = {
      app = "metube"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "metube"
      }
    }

    template {
      metadata {
        labels = {
          app = "metube"
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
          name  = "metube"
          image = var.image

          env {
            name  = "UID"
            value = "1000"
          }

          env {
            name  = "GID"
            value = "1000"
          }

          env {
            name  = "TZ"
            value = module.globals.timezone
          }

          # Optional: Set download quality preferences
          env {
            name  = "YTDL_OPTIONS"
            value = "{\"writesubtitles\": true, \"writeautomaticsub\": true, \"subtitleslangs\": [\"en\", \"es\"]}"
          }

          port {
            container_port = var.port
            name           = "http"
          }

          volume_mount {
            name       = "metube-downloads"
            mount_path = "/downloads"
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
            initial_delay_seconds = 30
            period_seconds        = 30
            timeout_seconds       = 10
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/"
              port = var.port
            }
            initial_delay_seconds = 15
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
            period_seconds        = 5
            timeout_seconds       = 3
            failure_threshold     = 20
          }
        }

        volume {
          name = "metube-downloads"
          persistent_volume_claim {
            claim_name = module.metube_downloads_storage.pvc_name
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
    module.metube_downloads_storage
  ]
}