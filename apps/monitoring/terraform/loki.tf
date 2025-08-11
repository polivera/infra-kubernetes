# Loki for log aggregation
resource "helm_release" "loki" {
  count      = local.enable_loki
  name       = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  version    = "6.35.1" # Check for latest version
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  values = [
    yamlencode({
      deploymentMode = "SingleBinary"

      loki = {
        auth_enabled = false
        commonConfig = {
          replication_factor = 1
        }
        storage = {
          type = "filesystem"
        }
        schemaConfig = {
          configs = [
            {
              from         = "2024-04-01"
              store        = "tsdb"
              object_store = "filesystem"
              schema       = "v13"
              index = {
                prefix = "index_"
                period = "24h"
              }
            }
          ]
        }
      }

      singleBinary = {
        replicas = 1
        persistence = {
          enabled          = true
          storageClassName = "slow"
          size             = var.loki_storage_size
        }
        resources = {
          requests = {
            memory = var.loki_memory_request
            cpu    = var.loki_cpu_request
          }
          limits = {
            memory = var.loki_memory_limit
            cpu    = var.loki_cpu_limit
          }
        }
      }

      # Disable other modes
      write = {
        replicas = 0
      }
      read = {
        replicas = 0
      }
      backend = {
        replicas = 0
      }
    })
  ]

  depends_on = [
    kubernetes_namespace.monitoring,
    module.loki_storage
  ]
}
