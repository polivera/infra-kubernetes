# apps/qbittorrent/terraform/qbittorrent.tf
resource "kubernetes_stateful_set" "qbittorrent" {
  metadata {
    name      = "qbittorrent"
    namespace = var.namespace
    labels = {
      app = "qbittorrent"
    }
  }

  spec {
    service_name = "qbittorrent-headless"
    replicas     = var.replicas

    selector {
      match_labels = {
        app = "qbittorrent"
      }
    }

    template {
      metadata {
        labels = {
          app = "qbittorrent"
        }
      }

      spec {
        dns_policy = "None"
        dns_config {
          nameservers = ["10.43.0.10", "192.168.0.1"]
          searches    = ["svc.cluster.local", "cluster.local"]
          option {
            name  = "ndots"
            value = "2"
          }
          option {
            name = "edns0"
          }
        }

        container {
          name  = "qbittorrent"
          image = var.image

          env {
            name = "PUID"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.qbittorrent.metadata[0].name
                key  = "PUID"
              }
            }
          }

          env {
            name = "PGID"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.qbittorrent.metadata[0].name
                key  = "PGID"
              }
            }
          }

          env {
            name = "TZ"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.qbittorrent.metadata[0].name
                key  = "TZ"
              }
            }
          }

          env {
            name = "WEBUI_PORT"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.qbittorrent.metadata[0].name
                key  = "WEBUI_PORT"
              }
            }
          }

          port {
            container_port = var.web_port
            name           = "webui"
            protocol       = "TCP"
          }

          port {
            container_port = var.torrent_port
            name           = "torrent-tcp"
            protocol       = "TCP"
          }

          port {
            container_port = var.torrent_port
            name           = "torrent-udp"
            protocol       = "UDP"
          }

          volume_mount {
            name       = "qbittorrent-config"
            mount_path = "/config"
          }

          volume_mount {
            name       = "qbittorrent-downloads"
            mount_path = "/downloads"
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

          liveness_probe {
            http_get {
              path = "/"
              port = var.web_port
            }
            initial_delay_seconds = 30
            period_seconds        = 30
            timeout_seconds       = 10
          }

          readiness_probe {
            http_get {
              path = "/"
              port = var.web_port
            }
            initial_delay_seconds = 15
            period_seconds        = 10
            timeout_seconds       = 5
          }
        }

        volume {
          name = "qbittorrent-config"
          persistent_volume_claim {
            claim_name = module.qbittorrent_config_storage.pvc_name
          }
        }

        volume {
          name = "qbittorrent-downloads"
          persistent_volume_claim {
            claim_name = module.qbittorrent_downloads_storage.pvc_name
          }
        }
      }
    }
  }

  depends_on = [
    module.qbittorrent_config_storage,
    module.qbittorrent_downloads_storage,
    kubernetes_config_map.qbittorrent
  ]
}
