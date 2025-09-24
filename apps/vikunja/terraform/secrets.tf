# apps/mysql/terraform/secrets.tf
resource "kubernetes_secret" "vikunja" {
  metadata {
    name      = "vikunja-secrets"
    namespace = var.namespace
  }
  type = "Opaque"
  data = {
    service-jtw-secret = sensitive(local.secrets.service_jtw_secret)
    database-user      = sensitive(local.secrets.database_user)
    database-password  = sensitive(local.secrets.database_password)
    database-name      = sensitive(local.secrets.database_name)
  }
}
