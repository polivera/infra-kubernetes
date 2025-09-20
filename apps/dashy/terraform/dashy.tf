# apps/dashy/terraform/dashy.tf
resource "kubernetes_deployment" "dashy" {
  metadata {
    name      = "dashy"
    namespace = var.namespace
    labels = {
      app = "dashy"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "dashy"
      }
    }

    template {
      metadata {
        labels = {
          app = "dashy"
        }
      }

      spec {
        container {
          name  = "dashy"
          image = var.image

          env {
            name  = "NODE_ENV"
            value = "production"
          }

          env {
            name  = "UID"
            value = "1000"
          }

          env {
            name  = "GID"
            value = "1000"
          }

          port {
            container_port = var.port
            name           = "http"
          }

          volume_mount {
            name       = "dashy-config-file"
            mount_path = "/app/public/conf.yml"
            sub_path   = "conf.yml"
          }

          volume_mount {
            name       = "dashy-data"
            mount_path = "/app/public"
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
            initial_delay_seconds = 10
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          startup_probe {
            http_get {
              path = "/"
              port = var.port
            }
            initial_delay_seconds = 5
            period_seconds        = 5
            timeout_seconds       = 3
            failure_threshold     = 30
          }
        }

        volume {
          name = "dashy-config-file"
          config_map {
            name = kubernetes_config_map.dashy.metadata[0].name
            items {
              key  = "conf.yml"
              path = "conf.yml"
            }
          }
        }

        volume {
          name = "dashy-data"
          persistent_volume_claim {
            claim_name = module.dashy_storage.pvc_name
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
    module.dashy_storage,
    kubernetes_config_map.dashy
  ]
}