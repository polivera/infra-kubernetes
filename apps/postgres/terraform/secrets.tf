locals {
  secrets = yamldecode(data.sops_file.secrets.raw)
}

resource "kubernetes_secret" "postgres" {
  metadata {
    name      = "postgres-secrets"
    namespace = var.namespace
  }
  type = "Opaque"
  data = {
    postgres-user = local.secrets.postgres_user
    postgres-password = local.secrets.postgres_password
  }
}