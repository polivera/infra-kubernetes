# Secrets for Gitea
resource "kubernetes_secret" "homarr" {
  metadata {
    name      = "homarr-secrets"
    namespace = var.namespace
  }
  type = "Opaque"
  data = {
    secret-encryption-key = sensitive(local.secrets.secret_encryption_key)
  }
}