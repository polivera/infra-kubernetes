# apps/homeassistant/terraform/homeassistant.tf
# Home Assistant StatefulSet
resource "kubernetes_stateful_set" "homeassistant" {
  metadata {
    name      = "homeassistant"
    namespace = var.namespace
    labels = {
      app = "homeassistant"
    }
  }

  spec {
    service_name = "homeassistant-headless"
    replicas     = var.replicas

    selector {
      match_labels = {
        app = "homeassistant"
      }
    }

    template {
      metadata {
        labels = {
          app = "homeassistant"
        }
      }

      spec {
        # Host network for device discovery and mDNS
        host_network = true
        dns_policy   = "ClusterFirstWithHostNet"

        dns_config {
          nameservers = module.globals.dns_nameservers
          searches    = module.globals.dns_searches
          option {
            name  = "ndots"
            value = "1"
          }
          option {
            name = "edns0"
          }
        }

        container {
          name  = "homeassistant"
          image = var.image

          env {
            name = "TZ"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.homeassistant.metadata[0].name
                key  = "TZ"
              }
            }
          }

          port {
            container_port = var.port
            name           = "http"
            protocol       = "TCP"
          }

          volume_mount {
            name       = "homeassistant-config"
            mount_path = "/config"
          }

          # Mount /dev for device access (USB dongles, etc.)
          volume_mount {
            name       = "dev"
            mount_path = "/dev"
          }

          # Mount /run/dbus for D-Bus communication
          volume_mount {
            name       = "dbus"
            mount_path = "/run/dbus"
            read_only  = true
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

          # Security context for privileged access
          security_context {
            privileged = var.privileged
          }

          liveness_probe {
            http_get {
              path = "/"
              port = var.port
            }
            initial_delay_seconds = 60
            period_seconds        = 30
            timeout_seconds       = 10
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/"
              port = var.port
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          startup_probe {
            http_get {
              path = "/"
              port = var.port
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 60  # Home Assistant can take time to start
          }
        }

        volume {
          name = "homeassistant-config"
          persistent_volume_claim {
            claim_name = module.homeassistant_storage.pvc_name
          }
        }

        volume {
          name = "dev"
          host_path {
            path = "/dev"
          }
        }

        volume {
          name = "dbus"
          host_path {
            path = "/run/dbus"
          }
        }

        # Node selector to run on specific node if needed
        # Uncomment and modify if you want to pin to a specific node
        # node_selector = {
        #   "kubernetes.io/hostname" = "your-node-name"
        # }

        # Tolerations for running on control plane if needed
        # toleration {
        #   key    = "node-role.kubernetes.io/control-plane"
        #   effect = "NoSchedule"
        # }
      }
    }
  }
}