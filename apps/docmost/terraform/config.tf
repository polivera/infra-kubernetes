# ConfigMap for Docmost
resource "kubernetes_config_map" "docmost" {
  metadata {
    name      = "docmost-config"
    namespace = var.namespace
  }

  data = {
    APP_URL           = "https://${local.app_url}"
    APP_SECRET        = "" # Will be overridden by secret
    DATABASE_URL      = "" # Will be overridden by secret
    REDIS_URL         = "" # Will be overridden by secret
    MAIL_DRIVER       = var.mail_driver
    MAIL_HOST         = var.mail_host
    MAIL_PORT         = tostring(var.mail_port)
    MAIL_USERNAME     = "" # Will be overridden by secret
    MAIL_PASSWORD     = "" # Will be overridden by secret
    MAIL_FROM_ADDRESS = var.mail_from_address
    MAIL_FROM_NAME    = var.mail_from_name
  }
}
