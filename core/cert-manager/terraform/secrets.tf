# Cloudflare API token secret
resource "kubernetes_secret" "cloudflare_api_token" {
  metadata {
    name      = var.cloudflare_secret_name
    namespace = kubernetes_namespace.cert_manager.metadata[0].name
  }

  type = "Opaque"

  data = {
    api-token = sensitive(local.secrets.cloudflare_api_token)
  }
}
