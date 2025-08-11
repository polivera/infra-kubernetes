# apps/development/terraform/postgres.tf

# PostgreSQL StatefulSet
resource "kubernetes_stateful_set" "postgres_dev" {
  metadata {
    name      = "postgres-dev"
    namespace = var.namespace
    labels = {
      app = "postgres-dev"
    }
  }

  spec {
    service_name = "postgres-dev-headless"
    replicas     = 1

    selector {
      match_labels = {
        app = "postgres-dev"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres-dev"
        }
      }

      spec {
        container {
          name  = "postgres"
          image = var.postgres_image

          env {
            name = "POSTGRES_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.postgres_dev.metadata[0].name
                key  = "postgres-user"
              }
            }
          }

          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.postgres_dev.metadata[0].name
                key  = "postgres-password"
              }
            }
          }

          env {
            name  = "PGDATA"
            value = "/var/lib/postgresql/data/pgdata"
          }

          port {
            container_port = var.postgres_port
            name          = "postgres"
          }

          volume_mount {
            name       = "postgres-data"
            mount_path = "/var/lib/postgresql/data"
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

          liveness_probe {
            exec {
              command = [
                "sh",
                "-c",
                "pg_isready -U $POSTGRES_USER"
              ]
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          readiness_probe {
            exec {
              command = [
                "sh",
                "-c",
                "pg_isready -U $POSTGRES_USER"
              ]
            }
            initial_delay_seconds = 5
            period_seconds        = 5
            timeout_seconds       = 3
            failure_threshold     = 3
          }
        }

        volume {
          name = "postgres-data"
          persistent_volume_claim {
            claim_name = module.postgres_dev_storage.pvc_name
          }
        }
      }
    }
  }

  depends_on = [
    module.postgres_dev_storage,
    kubernetes_secret.postgres_dev
  ]
}