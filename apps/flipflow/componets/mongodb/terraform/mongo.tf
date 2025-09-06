resource "kubernetes_stateful_set" "mongodb" {
  metadata {
    name      = "mongodb"
    namespace = data.kubernetes_namespace.mongodb.metadata[0].name
    labels = {
      app = "mongodb"
    }
  }

  spec {
    service_name = "mongodb-headless"
    replicas     = 1

    selector {
      match_labels = {
        app = "mongodb"
      }
    }

    template {
      metadata {
        labels = {
          app = "mongodb"
        }
      }

      spec {
        container {
          name  = "mongodb"
          image = var.mongodb_image

          env {
            name = "MONGO_INITDB_DATABASE"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.mongodb.metadata[0].name
                key  = "MONGO_INITDB_DATABASE"
              }
            }
          }

          port {
            container_port = var.mongodb_port
            name           = "mongodb"
          }

          volume_mount {
            name       = "mongodb-data"
            mount_path = "/var/lib/mongodb"
          }

          resources {
            requests = {
              memory = var.mongodb_request_memory
              cpu    = var.mongodb_request_cpu
            }
            limits = {
              memory = var.mongodb_limit_memory
              cpu    = var.mongodb_limit_cpu
            }
          }
        }

        volume {
          name = "mongodb-data"
          persistent_volume_claim {
            claim_name = module.mongodb_storage.pvc_name
          }
        }
      }
    }
  }

  depends_on = [
    module.mongodb_storage,
    kubernetes_config_map.mongodb
  ]
}
