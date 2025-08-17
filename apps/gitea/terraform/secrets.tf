# Secrets for Gitea
resource "kubernetes_secret" "gitea" {
  metadata {
    name      = "gitea-secrets"
    namespace = var.namespace
  }
  type = "Opaque"
  data = {
    database-password = sensitive(local.secrets.gitea_db_password)
    secret-key        = sensitive(local.secrets.gitea_secret_key)
    admin-user        = sensitive(local.secrets.gitea_admin_user)
    admin-password    = sensitive(local.secrets.gitea_admin_password)
    admin-email       = sensitive(local.secrets.gitea_admin_email)
  }
}