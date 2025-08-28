resource "kubernetes_deployment" "zookeeper" {
  count = var.enable_zookeeper
  metadata {
    name      = "zookeeper"
    namespace = kubernetes_namespace.flipflow.metadata[0].name
    labels = {
      app = "zookeeper"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "zookeeper"
      }
    }

    template {
      metadata {
        labels = {
          app = "zookeeper"
        }
      }

      spec {
        container {
          name  = "zookeeper"
          image = var.zookeeper_image

          port {
            container_port = 2181
            name           = "client"
          }
          port {
            container_port = 2888
            name           = "server"
          }
          port {
            container_port = 3888
            name           = "leader-election"
          }

          env {
            name  = "ZOO_MY_ID"
            value = "1"
          }

          env {
            name  = "ZOO_SERVER_ID"
            value = "1"
          }

          env {
            name  = "ZOO_SERVERS"
            value = "zookeeper:2888:3888:participant"
          }

          env {
            name  = "ALLOW_ANONYMOUS_LOGIN"
            value = "yes"
          }

          resources {
            requests = {
              memory = var.zookeeper_request_memory
              cpu    = var.zookeeper_request_cpu
            }
            limits = {
              memory = var.zookeeper_limit_memory
              cpu    = var.zookeeper_limit_cpu
            }
          }

          volume_mount {
            name       = "zookeeper-data"
            mount_path = "/data"
          }

          liveness_probe {
            tcp_socket {
              port = 2181
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          readiness_probe {
            tcp_socket {
              port = 2181
            }
            initial_delay_seconds = 5
            period_seconds        = 5
            timeout_seconds       = 1
            failure_threshold     = 3
          }
        }

        volume {
          name = "zookeeper-data"
          empty_dir {}
        }
      }
    }
  }
}
