# apps/mysql/terraform/config.tf
resource "kubernetes_config_map" "mysql" {
  metadata {
    name      = "mysql-config"
    namespace = var.namespace
  }
  data = {
    MYSQL_DATABASE = "flipflow"
  }
}