# apps/llm/terraform/webui-general.tf
# Open WebUI for General Use - Deployment
resource "kubernetes_deployment" "webui_general" {
  count = var.namespace_enabled ? 1 : 0

  metadata {
    name      = "webui-general"
    namespace = var.namespace
    labels = {
      app  = "webui-general"
      type = "general"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app  = "webui-general"
        type = "general"
      }
    }

    template {
      metadata {
        labels = {
          app  = "webui-general"
          type = "general"
        }
      }

      spec {
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
          name  = "webui-general"
          image = var.webui_image

          env {
            name  = "OLLAMA_BASE_URL"
            value = "http://ollama-headless:${var.ollama_port}"
          }

          env {
            name  = "WEBUI_NAME"
            value = "Vicugna Chat"
          }

          env {
            name  = "DEFAULT_MODELS"
            value = "llama3.2:3b,mistral:7b"
          }

          env {
            name  = "ENABLE_SIGNUP"
            value = "true"
          }

          env {
            name  = "WEBUI_AUTH"
            value = "true"
          }

          env {
            name  = "DEFAULT_USER_ROLE"
            value = "user"
          }

          env {
            name  = "FILE_SIZE_LIMIT"
            value = "100" # Size in MB, adjust as needed
          }

          port {
            container_port = var.webui_port
            name           = "http"
          }

          volume_mount {
            name       = "webui-data"
            mount_path = "/app/backend/data"
          }

          resources {
            requests = {
              memory = var.webui_request_memory
              cpu    = var.webui_request_cpu
            }
            limits = {
              memory = var.webui_limit_memory
              cpu    = var.webui_limit_cpu
            }
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = var.webui_port
            }
            initial_delay_seconds = 60
            period_seconds        = 30
            timeout_seconds       = 10
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = var.webui_port
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
          }

          startup_probe {
            http_get {
              path = "/health"
              port = var.webui_port
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 30
          }
        }

        volume {
          name = "webui-data"
          persistent_volume_claim {
            claim_name = module.webui_general_storage.pvc_name
          }
        }
      }
    }
  }

  depends_on = [
    module.webui_general_storage,
    kubernetes_stateful_set.ollama
  ]
}
