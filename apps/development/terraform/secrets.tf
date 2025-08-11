# apps/development/terraform/secrets.tf
locals {
  secrets = yamldecode(data.sops_file.secrets.raw)
}

# PostgreSQL Secrets
resource "kubernetes_secret" "postgres_dev" {
  metadata {
    name      = "postgres-dev-secrets"
    namespace = var.namespace
  }
  type = "Opaque"
  data = {
    postgres-user     = sensitive(local.secrets.dev_postgres_user)
    postgres-password = sensitive(local.secrets.dev_postgres_password)
  }
}

# Redis Secrets (for AUTH if needed)
resource "kubernetes_secret" "redis_dev" {
  metadata {
    name      = "redis-dev-secrets"
    namespace = var.namespace
  }
  type = "Opaque"
  data = {
    redis-password = sensitive(local.secrets.dev_redis_password)
  }
}