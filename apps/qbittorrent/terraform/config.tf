# apps/qbittorrent/terraform/config.tf
resource "kubernetes_config_map" "qbittorrent" {
  metadata {
    name      = "qbittorrent-config"
    namespace = var.namespace
  }

  data = {
    PUID     = var.puid
    PGID     = var.pgid
    TZ       = var.timezone
    WEBUI_PORT = tostring(var.web_port)
  }
}
