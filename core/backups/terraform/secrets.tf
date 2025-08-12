# apps/backup/terraform/secrets.tf
locals {
  secrets = yamldecode(data.sops_file.secrets.raw)
}

# Secrets for database connections
resource "kubernetes_secret" "backup_secrets" {
  metadata {
    name      = "backup-secrets"
    namespace = var.namespace
  }
  type = "Opaque"
  data = {
    # Postgres credentials
    postgres-user     = local.secrets.postgres_user
    postgres-password = local.secrets.postgres_password

    # MySQL credentials (add these to your secrets.enc.yaml when needed)
    # mysql-user        = try(local.secrets.mysql_user, "")
    # mysql-password    = try(local.secrets.mysql_password, "")
    # mysql-root-password = try(local.secrets.mysql_root_password, "")
  }
}