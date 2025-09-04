resource "kubernetes_config_map" "mysql" {
  metadata {
    name      = "mysql-config"
    namespace = data.kubernetes_namespace.mysql.metadata[0].name
  }
  data = {
    MYSQL_DATABASE = "flipflow"
  }
}
