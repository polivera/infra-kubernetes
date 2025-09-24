resource "kubernetes_config_map" "vikunja" {
  metadata {
    name      = "vikunja-config"
    namespace = var.namespace
  }
  data = {
    VIKUNJA_DATABASE_HOST = "mysql.mysql.svc.cluster.local"
    VIKUNJA_SERVICE_PUBLICURL = "https://${local.app_url}"
    VIKUNJA_DATABASE_TYPE = "mysql"
  }
}
