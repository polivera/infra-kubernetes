resource "kubernetes_config_map" "mongodb" {
  metadata {
    name      = "mongodb-config"
    namespace = data.kubernetes_namespace.mongodb.metadata[0].name
  }
  data = {
    MONGO_INITDB_DATABASE = "CrawlMaster"
  }
}
