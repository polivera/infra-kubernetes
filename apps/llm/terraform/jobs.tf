# apps/llm/terraform/jobs.tf
# Job to pull initial models
resource "kubernetes_job_v1" "model_setup" {
  metadata {
    name      = "model-setup"
    namespace = var.namespace
  }

  spec {
    template {
      metadata {
        name = "model-setup"
      }

      spec {
        restart_policy = "OnFailure"

        container {
          name  = "model-setup"
          image = "curlimages/curl:latest"

          command = ["/bin/sh"]
          args = [
            "-c",
            <<-EOF
            echo "Waiting for Ollama to be ready..."
            until curl -f http://ollama-headless:11434/api/tags; do
              echo "Waiting for Ollama API..."
              sleep 10
            done

            echo "Ollama is ready! Pulling models..."

            # Pull coding models
            echo "Pulling CodeLlama 7B Code..."
            curl -X POST http://ollama-headless:${var.ollama_port}/api/pull -d '{"name": "codellama:7b-code"}'

            echo "Pulling DeepSeek Coder 6.7B..."
            curl -X POST http://ollama-headless:${var.ollama_port}/api/pull -d '{"name": "deepseek-coder:6.7b"}'

            # Pull general models
            echo "Pulling Llama 3.2 3B..."
            curl -X POST http://ollama-headless:${var.ollama_port}/api/pull -d '{"name": "llama3.2:3b"}'

            echo "Pulling Mistral 7B..."
            curl -X POST http://ollama-headless:${var.ollama_port}/api/pull -d '{"name": "mistral:7b"}'

            echo "All models pulled successfully!"
            EOF
          ]
        }
      }
    }

    backoff_limit              = 3
    ttl_seconds_after_finished = 3600
  }

  depends_on = [kubernetes_stateful_set.ollama]
}
