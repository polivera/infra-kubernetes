# apps/llm/terraform/webui-coding.tf
# Open WebUI for Coding - Deployment
resource "kubernetes_deployment" "webui_coding" {
  metadata {
    name      = "webui-coding"
    namespace = var.namespace
    labels = {
      app  = "webui-coding"
      type = "coding"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app  = "webui-coding"
        type = "coding"
      }
    }

    template {
      metadata {
        labels = {
          app  = "webui-coding"
          type = "coding"
        }
      }

      spec {
        container {
          name  = "webui-coding"
          image = var.webui_image

          env {
            name  = "OLLAMA_BASE_URL"
            value = "http://ollama-headless:${var.ollama_port}"
          }

          env {
            name  = "WEBUI_NAME"
            value = "Vicugna Code Assistant"
          }

          env {
            name  = "DEFAULT_MODELS"
            value = "codellama:7b-code,deepseek-coder:6.7b"
          }

          env {
            name  = "ENABLE_SIGNUP"
            value = "false"
          }

          env {
            name  = "WEBUI_AUTH"
            value = "true"
          }

          port {
            container_port = var.webui_port
            name          = "http"
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
            claim_name = module.webui_coding_storage.pvc_name
          }
        }
      }
    }
  }

  depends_on = [
    module.webui_coding_storage,
    kubernetes_stateful_set.ollama
  ]
}
