resource "kubernetes_secret" "paperless" {
  metadata {
    name      = "paperless-secrets"
    namespace = var.namespace
  }

  type = "Opaque"

  data = {
    secret-key          = sensitive(local.secrets.paperless_secret_key)
    admin-user          = sensitive(local.secrets.paperless_admin_user)
    admin-password      = sensitive(local.secrets.paperless_admin_password)
    admin-mail          = sensitive(local.secrets.paperless_admin_mail)
    database-host       = sensitive(local.secrets.paperless_database_host)
    database-user       = sensitive(local.secrets.paperless_database_user)
    database-pass       = sensitive(local.secrets.paperless_database_password)
    database-name       = sensitive(local.secrets.paperless_database_name)
    redis-url           = sensitive(local.secrets.paperless_redis_url)
  }
}