# apps/valkey/terraform/valkey.tf
resource "kubernetes_stateful_set" "valkey" {
  metadata {
    name      = "valkey"
    namespace = kubernetes_namespace.valkey.metadata[0].name
    labels = {
      app = "valkey"
    }
  }

  spec {
    service_name = "valkey-headless"
    replicas     = var.replicas

    selector {
      match_labels = {
        app = "valkey"
      }
    }

    template {
      metadata {
        labels = {
          app = "valkey"
        }
      }

      spec {
        container {
          name  = "valkey"
          image = var.image

          command = ["valkey-server", "/usr/local/etc/valkey/valkey.conf"]

          port {
            container_port = var.port
            name           = "valkey"
          }

          volume_mount {
            name       = "valkey-data"
            mount_path = "/data"
          }

          volume_mount {
            name       = "valkey-config"
            mount_path = "/usr/local/etc/valkey"
            read_only  = true
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
            tcp_socket {
              port = var.port
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          readiness_probe {
            tcp_socket {
              port = var.port
            }
            initial_delay_seconds = 5
            period_seconds        = 5
            timeout_seconds       = 1
            failure_threshold     = 3
          }

          startup_probe {
            tcp_socket {
              port = var.port
            }
            initial_delay_seconds = 10
            period_seconds        = 5
            timeout_seconds       = 1
            failure_threshold     = 30
          }
        }

        volume {
          name = "valkey-data"
          persistent_volume_claim {
            claim_name = module.valkey_storage.pvc_name
          }
        }

        volume {
          name = "valkey-config"
          config_map {
            name = kubernetes_config_map.valkey.metadata[0].name
            items {
              key  = "valkey.conf"
              path = "valkey.conf"
            }
          }
        }

        # Security context
        security_context {
          fs_group = 999
        }
      }
    }
  }

  depends_on = [
    module.valkey_storage,
    kubernetes_config_map.valkey
  ]
}
