resource "kubernetes_config_map" "postgres" {
  metadata {
    name      = "postgres-config"
    namespace = var.namespace
  }
  data = {
    POSTGRES_DB = "postgres"
  }
}
