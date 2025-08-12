# kubernetes/heimdall/terraform/heimdall.tf
# Heimdall Deployment
resource "kubernetes_deployment" "heimdall" {
  metadata {
    name      = "heimdall"
    namespace = var.namespace
    labels = {
      app = "heimdall"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "heimdall"
      }
    }

    template {
      metadata {
        labels = {
          app = "heimdall"
        }
      }

      spec {
        dns_config {
          nameservers = ["10.43.0.10", "192.168.0.1"]
          searches    = ["svc.cluster.local", "cluster.local"]
          option {
            name  = "ndots"
            value = "2"
          }
          option {
            name = "edns0"
          }
        }
        container {
          name  = "heimdall"
          image = var.image

          port {
            name           = "http"
            container_port = var.port
            protocol       = "TCP"
          }

          port {
            name           = "https"
            container_port = 443
            protocol       = "TCP"
          }

          env {
            name  = "PUID"
            value = "3000"
          }

          env {
            name  = "PGID"
            value = "3000"
          }

          env {
            name  = "TZ"
            value = "Europe/Madrid"
          }

          volume_mount {
            name       = "config"
            mount_path = "/config"
          }

          resources {
            requests = {
              memory = var.request_memory
              cpu    = var.requested_cpu
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
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/"
              port = var.port
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }
        }

        volume {
          name = "config"
          persistent_volume_claim {
            claim_name = module.heimdall_config_storage.pvc_name
          }
        }
      }
    }
  }

  depends_on =  [module.heimdall_config_storage]
}
