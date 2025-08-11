# apps/development/terraform/redis.tf

# Redis StatefulSet
resource "kubernetes_stateful_set" "redis_dev" {
  metadata {
    name      = "redis-dev"
    namespace = var.namespace
    labels = {
      app = "redis-dev"
    }
  }

  spec {
    service_name = "redis-dev-headless"
    replicas     = 1

    selector {
      match_labels = {
        app = "redis-dev"
      }
    }

    template {
      metadata {
        labels = {
          app = "redis-dev"
        }
      }

      spec {
        container {
          name  = "redis"
          image = var.redis_image

          port {
            container_port = var.redis_port
            name          = "redis"
          }

          volume_mount {
            name       = "redis-data"
            mount_path = "/data"
          }


          resources {
            requests = {
              memory = var.redis_request_memory
              cpu    = var.redis_request_cpu
            }
            limits = {
              memory = var.redis_limit_memory
              cpu    = var.redis_limit_cpu
            }
          }

          liveness_probe {
            exec {
              command = ["redis-cli", "ping"]
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          readiness_probe {
            exec {
              command = ["redis-cli", "ping"]
            }
            initial_delay_seconds = 5
            period_seconds        = 5
            timeout_seconds       = 3
            failure_threshold     = 3
          }
        }

        volume {
          name = "redis-data"
          persistent_volume_claim {
            claim_name = module.redis_dev_storage.pvc_name
          }
        }
      }
    }
  }

  depends_on = [
    module.redis_dev_storage,
    kubernetes_secret.redis_dev
  ]
}