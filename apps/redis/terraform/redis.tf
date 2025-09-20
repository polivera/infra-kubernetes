# apps/redis/terraform/redis.tf
resource "kubernetes_stateful_set" "redis" {
  metadata {
    name      = "redis"
    namespace = var.namespace
    labels = {
      app = "redis"
    }
  }

  spec {
    service_name = "redis-headless"
    replicas     = 1

    selector {
      match_labels = {
        app = "redis"
      }
    }

    template {
      metadata {
        labels = {
          app = "redis"
        }
      }

      spec {
        container {
          name  = "redis"
          image = var.image

          args = ["redis-server", "/etc/redis/redis.conf"]

          port {
            container_port = var.port
            name           = "redis"
          }

          volume_mount {
            name       = "redis-data"
            mount_path = "/data"
          }

          volume_mount {
            name       = "redis-config"
            mount_path = "/etc/redis"
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
            exec {
              command = ["redis-cli", "ping"]
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          readiness_probe {
            exec {
              command = ["redis-cli", "ping"]
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }
        }

        volume {
          name = "redis-data"
          persistent_volume_claim {
            claim_name = module.redis_storage.pvc_name
          }
        }

        volume {
          name = "redis-config"
          config_map {
            name = kubernetes_config_map.redis.metadata[0].name
            items {
              key  = "redis_conf"
              path = "redis.conf"
            }
          }
        }
      }
    }
  }

  depends_on = [
    module.redis_storage
  ]
}
