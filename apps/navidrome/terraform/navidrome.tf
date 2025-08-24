# apps/navidrome/terraform/navidrome.tf
# Navidrome Deployment
resource "kubernetes_deployment" "navidrome" {
  metadata {
    name      = "navidrome"
    namespace = var.namespace
    labels = {
      app = "navidrome"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "navidrome"
      }
    }

    template {
      metadata {
        labels = {
          app = "navidrome"
        }
      }

      spec {
        dns_config {
          nameservers = module.globals.dns_nameservers
          searches    = module.globals.dns_searches
          option {
            name  = "ndots"
            value = "2"
          }
          option {
            name = "edns0"
          }
        }

        container {
          name  = "navidrome"
          image = var.image

          port {
            name           = "http"
            container_port = var.port
            protocol       = "TCP"
          }

          env {
            name  = "ND_MUSICFOLDER"
            value = "/music"
          }

          env {
            name  = "ND_DATAFOLDER"
            value = "/data"
          }

          env {
            name  = "ND_PORT"
            value = tostring(var.port)
          }

          env {
            name  = "ND_LOGLEVEL"
            value = var.log_level
          }

          env {
            name  = "ND_SCANSCHEDULE"
            value = var.scan_schedule
          }

          env {
            name  = "ND_TRANSCODINGCACHESIZE"
            value = var.transcoding_cache_size
          }

          env {
            name  = "ND_SESSIONTIMEOUT"
            value = var.session_timeout
          }

          env {
            name  = "ND_BASEURL"
            value = "https://${local.app_url}"
          }

          env {
            name  = "ND_ENABLETRANSCODINGCONFIG"
            value = "true"
          }

          env {
            name  = "ND_ENABLEDOWNLOADS"
            value = tostring(var.enable_downloads)
          }

          env {
            name  = "ND_ENABLEFAVOURITES"
            value = "true"
          }

          env {
            name  = "ND_ENABLESTARRATING"
            value = "true"
          }

          env {
            name  = "ND_COVERARTPRIORITY"
            value = "embedded, cover.*, folder.*"
          }

          env {
            name  = "ND_ENABLEEXTERNALSERVICES"
            value = tostring(var.enable_external_services)
          }

          volume_mount {
            name       = "navidrome-data"
            mount_path = "/data"
          }

          volume_mount {
            name       = "navidrome-music"
            mount_path = "/music"
            read_only  = var.music_readonly
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
              path = "/ping"
              port = var.port
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/ping"
              port = var.port
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }
        }

        volume {
          name = "navidrome-data"
          persistent_volume_claim {
            claim_name = module.navidrome_data_storage.pvc_name
          }
        }

        volume {
          name = "navidrome-music"
          persistent_volume_claim {
            claim_name = module.navidrome_music_storage.pvc_name
          }
        }
      }
    }
  }

  depends_on = [
    module.navidrome_data_storage,
    module.navidrome_music_storage
  ]
}
