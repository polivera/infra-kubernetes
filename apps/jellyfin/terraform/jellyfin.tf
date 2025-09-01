# Jellyfin deployment
resource "kubernetes_deployment" "jellyfin" {
  metadata {
    name      = "jellyfin"
    namespace = var.namespace
    labels = {
      app = "jellyfin"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "jellyfin"
      }
    }

    template {
      metadata {
        labels = {
          app = "jellyfin"
        }
      }

      spec {
        # Node selector for GPU node (optional)
        node_selector = {
          "kubernetes.io/hostname" = "zeratul" # Change to your GPU node name
        }

        dns_config {
          nameservers = module.globals.dns_nameservers
          searches    = module.globals.dns_searches
          option {
            name  = "ndots"
            value = "2"
          }
          option {
            name = "edns0"
          }
        }

        container {
          name  = "jellyfin"
          image = var.image

          port {
            container_port = var.port
          }

          env {
            name  = "JELLYFIN_PublishedServerUrl"
            value = "https://${var.hostname}"
          }

          volume_mount {
            name       = "jellyfin-config"
            mount_path = "/config"
          }

          volume_mount {
            name       = "jellyfin-cache"
            mount_path = "/cache"
          }

          volume_mount {
            name       = "jellyfin-movies"
            mount_path = "/movies"
            read_only  = true
          }

          volume_mount {
            name       = "jellyfin-youtube"
            mount_path = "/youtube"
            read_only  = true
          }

          volume_mount {
            name       = "jellyfin-anime"
            mount_path = "/anime"
            read_only  = true
          }

          resources {
            requests = {
              memory = var.request_memory
              cpu    = var.request_cpu
            }
            limits = {
              memory = var.limit_memory
              cpu    = var.limit_cpu
            }
          }
        }

        volume {
          name = "jellyfin-config"
          persistent_volume_claim {
            claim_name = module.jellyfin_config_storage.pvc_name
          }
        }

        volume {
          name = "jellyfin-cache"
          persistent_volume_claim {
            claim_name = module.jellyfin_cache_storage.pvc_name
          }
        }

        volume {
          name = "jellyfin-movies"
          persistent_volume_claim {
            claim_name = module.jellyfin_movies_storage.pvc_name
          }
        }
        volume {
          name = "jellyfin-youtube"
          persistent_volume_claim {
            claim_name = module.jellyfin_youtube_storage.pvc_name
          }
        }
        volume {
          name = "jellyfin-anime"
          persistent_volume_claim {
            claim_name = module.jellyfin_anime_storage.pvc_name
          }
        }
      }
    }
  }

  depends_on = [
    module.jellyfin_movies_storage,
    module.jellyfin_anime_storage,
    module.jellyfin_youtube_storage
  ]
}
