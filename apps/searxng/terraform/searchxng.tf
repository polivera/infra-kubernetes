# apps/searxng/terraform/searxng.tf
# SearXNG Deployment
resource "kubernetes_stateful_set" "searxng" {
  metadata {
    name      = "searxng"
    namespace = var.namespace
    labels = {
      app = "searxng"
    }
  }

  spec {
    service_name = "searxng-headless"
    replicas     = 1

    selector {
      match_labels = {
        app = "searxng"
      }
    }

    template {
      metadata {
        labels = {
          app = "searxng"
        }
      }

      spec {
        container {
          name  = "searxng"
          image = var.image

          env_from {
            config_map_ref {
              name = kubernetes_config_map.searxng.metadata[0].name
            }
          }

          env {
            name = "SEARXNG_SECRET"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.searxng.metadata[0].name
                key  = "secret-key"
              }
            }
          }

          env {
            name = "SEARXNG_VALKEY_URL"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.searxng.metadata[0].name
                key  = "valkey-url"
              }
            }
          }

          port {
            container_port = var.port
            name           = "http"
          }

          volume_mount {
            name       = "searxng-config"
            mount_path = "/etc/searxng"
          }

          volume_mount {
            name       = "searxng-cache"
            mount_path = "/var/cache/searxng"
          }

          resources {
            requests = {
              cpu    = var.request_cpu
              memory = var.request_memory
            }
            limits = {
              cpu    = var.limit_cpu
              memory = var.limit_memory
            }
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = var.port
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/healthz"
              port = var.port
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }

          security_context {
            run_as_non_root = true
            run_as_user     = 977
            run_as_group    = 977
            capabilities {
              drop = ["ALL"]
              add  = ["CHOWN", "SETGID", "SETUID", "DAC_OVERRIDE"]
            }
          }
        }

        volume {
          name = "searxng-config"
          persistent_volume_claim {
            claim_name = module.searxng_config_storage.pvc_name
          }
        }

        volume {
          name = "searxng-cache"
          persistent_volume_claim {
            claim_name = module.searxng_cache_storage.pvc_name
          }
        }

        restart_policy = "Always"
      }
    }
  }
}