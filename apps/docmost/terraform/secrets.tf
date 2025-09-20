resource "kubernetes_secret" "docmost" {
  metadata {
    name      = "docmost-secrets"
    namespace = var.namespace
  }
  type = "Opaque"
  data = {
    app-secret    = local.secrets.docmost_app_secret
    database-url  = local.secrets.docmost_database_url
    redis-url     = local.secrets.docmost_redis_url
    mail-user     = local.secrets.docmost_mail_user
    mail-password = local.secrets.docmost_mail_password
  }
}
