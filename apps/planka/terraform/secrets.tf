# apps/planka/terraform/secrets.tf
resource "kubernetes_secret" "planka" {
  metadata {
    name      = "planka-secrets"
    namespace = var.namespace
  }
  type = "Opaque"
  data = {
    database-url           = sensitive(local.secrets.planka_database_url)
    secret-key             = sensitive(local.secrets.planka_secret_key)
    default-admin-email    = sensitive(local.secrets.planka_default_admin_email)
    default-admin-password = sensitive(local.secrets.planka_default_admin_password)
    default-admin-name     = sensitive(local.secrets.planka_default_admin_name)
    default-admin-username = sensitive(local.secrets.planka_default_admin_username)
  }
}
