# apps/searxng/terraform/secrets.tf
resource "kubernetes_secret" "searxng" {
  metadata {
    name      = "searxng-secrets"
    namespace = var.namespace
  }
  type = "Opaque"
  data = {
    secret-key = sensitive(local.secrets.searxng_secret_key)
    valkey-url = sensitive(local.secrets.searxng_valkey_url)
  }
}