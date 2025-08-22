# apps/llm/terraform/ollama.tf
# Ollama StatefulSet
resource "kubernetes_stateful_set" "ollama" {
  count = var.namespace_enabled ? 1 : 0
  metadata {
    name      = "ollama"
    namespace = var.namespace
    labels = {
      app = "ollama"
    }
  }

  spec {
    service_name = "ollama-headless"
    replicas     = 1

    selector {
      match_labels = {
        app = "ollama"
      }
    }

    template {
      metadata {
        labels = {
          app = "ollama"
        }
      }

      spec {
        # Node selector for GPU node (optional)
        node_selector = {
          "kubernetes.io/hostname" = "zeratul" # Change to your GPU node name
        }

        # Add runtime class for NVIDIA GPU support
        runtime_class_name = "nvidia"

        dns_config {
          nameservers = module.globals.dns_nameservers
          searches    = module.globals.dns_searches
          option {
            name  = "ndots"
            value = "2"
          }
          option {
            name = "edns0"
          }
        }

        container {
          name  = "ollama"
          image = var.ollama_image

          env {
            name  = "OLLAMA_HOST"
            value = "0.0.0.0"
          }

          # Uncomment if you have GPU available
          env {
            name  = "NVIDIA_VISIBLE_DEVICES"
            value = "all"
          }

          env {
            name  = "NVIDIA_DRIVER_CAPABILITIES"
            value = "compute,utility"
          }

          port {
            container_port = var.ollama_port
            name          = "api"
          }

          volume_mount {
            name       = "ollama-data"
            mount_path = "/root/.ollama"
          }

          resources {
            requests = {
              memory = var.ollama_request_memory
              cpu    = var.ollama_request_cpu
            }
            limits = {
              memory = var.ollama_limit_memory
              cpu    = var.ollama_limit_cpu
              # Uncomment if you have GPU
              "nvidia.com/gpu" = "1"
            }
          }

          liveness_probe {
            http_get {
              path = "/api/tags"
              port = var.ollama_port
            }
            initial_delay_seconds = 60
            period_seconds        = 30
            timeout_seconds       = 10
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/api/tags"
              port = var.ollama_port
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          startup_probe {
            http_get {
              path = "/api/tags"
              port = var.ollama_port
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 60
          }
        }

        volume {
          name = "ollama-data"
          persistent_volume_claim {
            claim_name = module.ollama_storage.pvc_name
          }
        }
      }
    }
  }

  depends_on = [module.ollama_storage]
}
