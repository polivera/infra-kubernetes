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
        } : {}

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

          dynamic "port" {
            for_each = var.ports
            content {
              name = port.value.name
              container_port = port.value.port
              protocol = port.value.protocol
            }
          }

          dynamic "env" {
            for_each = var.envs
            content {
              name  = env.key
              value = env.value.value
            }
          }

          dynamic "env" {
            for_each = var.env_secrets
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

          dynamic "env" {
            for_each = var.env_configs
            content {
              name = env.key
              value_from {
                config_map_key_ref {
                  name = env.value.config_name
                  key  = env.value.config_key
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

          dynamic "readiness_probe" {
            for_each = var.http_probe != null ? [1] : []
            content {
              http_get {
                path = var.http_probe
                port = var.http_probe_port
              }
              initial_delay_seconds = 30
              period_seconds        = 10
            }
          }

          dynamic "liveness_probe" {
            for_each = var.http_probe != null ? [1] : []
            content {
              http_get {
                path = var.http_probe
                port = var.http_probe_port
              }
              initial_delay_seconds = 30
              period_seconds        = 10
            }
          }

          dynamic "readiness_probe" {
            for_each = var.command_probe != null ? [1] : []
            content {
              exec {
                command = var.command_probe
              }
              initial_delay_seconds = 30
              period_seconds        = 10
            }
          }

          dynamic "liveness_probe" {
            for_each = var.command_probe != null ? [1] : []
            content {
              exec {
                command = var.command_probe
              }
              initial_delay_seconds = 30
              period_seconds        = 10
            }
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

        # TODO: Add this
        # security_context {
        #   fs_group = 1000
        # }
      }
    }
  }
}
