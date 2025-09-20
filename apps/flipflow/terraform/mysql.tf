# apps/mysql/terraform/mysql.tf
# MySQL StatefulSet
resource "kubernetes_stateful_set" "mysql" {
  count = var.enable_mysql
  metadata {
    name      = "mysql"
    namespace = var.namespace
    labels = {
      app = "mysql"
    }
  }

  spec {
    service_name = "mysql-headless"
    replicas     = 1

    selector {
      match_labels = {
        app = "mysql"
      }
    }

    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }

      spec {
        container {
          name  = "mysql"
          image = var.mysql_image

          env {
            name = "MYSQL_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql.metadata[0].name
                key  = "mysql-root-password"
              }
            }
          }

          env {
            name = "MYSQL_DATABASE"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.mysql.metadata[0].name
                key  = "MYSQL_DATABASE"
              }
            }
          }

          env {
            name = "MYSQL_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql.metadata[0].name
                key  = "mysql-user"
              }
            }
          }

          env {
            name = "MYSQL_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql.metadata[0].name
                key  = "mysql-password"
              }
            }
          }

          port {
            container_port = var.mysql_port
            name           = "mysql"
          }

          volume_mount {
            name       = "mysql-data"
            mount_path = "/var/lib/mysql"
          }

          resources {
            requests = {
              memory = var.mysql_request_memory
              cpu    = var.mysql_request_cpu
            }
            limits = {
              memory = var.mysql_limit_memory
              cpu    = var.mysql_limit_cpu
            }
          }

          liveness_probe {
            exec {
              command = [
                "sh",
                "-c",
                "mysqladmin ping -h localhost -u root -p$MYSQL_ROOT_PASSWORD"
              ]
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
          }

          readiness_probe {
            exec {
              command = [
                "sh",
                "-c",
                "mysql -h localhost -u root -p$MYSQL_ROOT_PASSWORD -e 'SELECT 1'"
              ]
            }
            initial_delay_seconds = 5
            period_seconds        = 5
            timeout_seconds       = 1
          }
        }

        volume {
          name = "mysql-data"
          persistent_volume_claim {
            claim_name = module.mysql_storage.pvc_name
          }
        }
      }
    }
  }

  depends_on = [
    module.mysql_storage,
    kubernetes_config_map.mysql,
    kubernetes_secret.mysql
  ]
}