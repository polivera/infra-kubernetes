resource "kubernetes_deployment" "postgres" {
  count = var.enable_postgres
  metadata {
    name      = "postgres"
    namespace = kubernetes_namespace.flipflow.metadata[0].name
    labels = {
      app = "postgres"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {
        container {
          name  = "postgres"
          image = var.postgres_image

          env {
            name  = "POSTGRES_DB"
            value = "druid"
          }
          env {
            name  = "POSTGRES_USER"
            value = "druid"
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = "druid123"
          }

          port {
            container_port = 5432
            name           = "postgres"
          }

          resources {
            requests = {
              memory = var.postgres_request_memory
              cpu    = var.postgres_request_cpu
            }
            limits = {
              memory = var.postgres_limit_memory
              cpu    = var.postgres_limit_cpu
            }
          }

          volume_mount {
            name       = "postgres-data"
            mount_path = "/var/lib/postgresql/data"
          }

          liveness_probe {
            exec {
              command = ["pg_isready", "-U", "druid"]
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          readiness_probe {
            exec {
              command = ["pg_isready", "-U", "druid"]
            }
            initial_delay_seconds = 5
            period_seconds        = 5
            timeout_seconds       = 1
            failure_threshold     = 3
          }
        }

        volume {
          name = "postgres-data"
          persistent_volume_claim {
            claim_name = module.postgres_storage[0].pvc_name
          }
        }
      }
    }
  }

  depends_on = [
    module.postgres_storage
  ]
}
