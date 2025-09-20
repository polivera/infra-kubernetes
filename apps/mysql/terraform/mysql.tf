# apps/mysql/terraform/mysql.tf
# MySQL StatefulSet
resource "kubernetes_stateful_set" "mysql" {
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
          image = var.image

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
            container_port = var.port
            name           = "mysql"
          }

          volume_mount {
            name       = "mysql-data"
            mount_path = "/var/lib/mysql"
          }

          volume_mount {
            name       = "mysql-config"
            mount_path = "/etc/mysql/conf.d"
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
              command = [
                "mysqladmin",
                "ping",
                "-h",
                "localhost",
                "-u",
                "root",
                "-p${MYSQL_ROOT_PASSWORD}"
              ]
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
          }

          readiness_probe {
            exec {
              command = [
                "mysql",
                "-h",
                "localhost",
                "-u",
                "root",
                "-p${MYSQL_ROOT_PASSWORD}",
                "-e",
                "SELECT 1"
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

        volume {
          name = "mysql-config"
          config_map {
            name = kubernetes_config_map.mysql.metadata[0].name
            items {
              key  = "my_cnf"
              path = "my.cnf"
            }
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