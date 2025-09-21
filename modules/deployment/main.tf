resource "kubernetes_deployment" "this" {
  metadata {
    name      = coalesce(var.app_name, var.namespace)
    namespace = var.namespace
    labels = {
      app = coalesce(var.app_name, var.namespace)
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = coalesce(var.app_name, var.namespace)
      }
    }

    template {
      metadata {
        labels = {
          app = coalesce(var.app_name, var.namespace)
        }
      }

      spec {

        node_selector = var.gpu_node_hostname != "" ? {
          "kubernetes.io/hostname" = var.gpu_node_hostname
        } : null

        dns_config {
          nameservers = var.dns_nameserver
          searches    = var.dns_searches
          option {
            name  = "ndots"
            value = "2"
          }
          option {
            name = "edns0"
          }
        }

        container {
          name  = coalesce(var.app_name, var.namespace)
          image = var.image

          port {
            name           = "http"
            container_port = var.port
            protocol       = "TCP"
          }

          dynamic "env" {
            for_each = var.env_configs
            content {
              name  = env.key
              value = env.value.value
            }
          }

          dynamic "env" {
            for_each = var.env_secrets_configs
            content {
              name = env.key
              value_from {
                secret_key_ref {
                  name = env.value.secret_name
                  key  = env.value.secret_key
                }
              }
            }
          }

          dynamic "volume_mount" {
            for_each = var.mounts
            content {
              name       = volume_mount.value.name
              mount_path = volume_mount.value.mount_path
              read_only  = volume_mount.value.read_only
            }

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

        dynamic "volume" {
          for_each = var.claims
          content {
            name = volume.value.name
            persistent_volume_claim {
              claim_name = volume.value.claim_name
            }
          }
        }
      }
    }
  }
}
