# apps/qbittorrent/terraform/qbittorrent.tf
module "qbittorrent_stateful_set" {
  source          = "../../../modules/statefulset"
  app_name        = var.namespace
  namespace       = var.namespace
  service_name    = "${var.namespace}-headless"
  image           = var.image
  request_cpu     = var.request_cpu
  request_memory  = var.request_memory
  limit_cpu       = var.limit_cpu
  limit_memory    = var.limit_memory
  http_probe      = "/"
  http_probe_port = var.web_port
  ports = [
    {
      port     = var.web_port
      name     = "webui"
      protocol = "TCP"
    },
    {
      port     = var.torrent_port
      name     = "torrent-tcp"
      protocol = "TCP"
    },
    {
      port     = var.torrent_port
      name     = "torrent-udp"
      protocol = "UDP"
    }
  ]
  env_configs = {
    PUID = {
      config_name = kubernetes_config_map.qbittorrent.metadata[0].name
      config_key  = "PUID"
    }
    PGID = {
      config_name = kubernetes_config_map.qbittorrent.metadata[0].name
      config_key  = "PGID"
    }
    TZ = {
      config_name = kubernetes_config_map.qbittorrent.metadata[0].name
      config_key  = "TZ"
    }
    WEBUI_PORT = {
      config_name = kubernetes_config_map.qbittorrent.metadata[0].name
      config_key  = "WEBUI_PORT"
    }
  }
  mounts = [
    {
      name       = "qbittorrent-config"
      mount_path = "/config"
      read_only  = false
    },
    {
      name       = "qbittorrent-downloads"
      mount_path = "/downloads"
      read_only  = false
    }
  ]
  claims = [
    {
      name       = "qbittorrent-config"
      claim_name = module.qbittorrent_config_storage.pvc_name
    },
    {
      name       = "qbittorrent-downloads"
      claim_name = module.qbittorrent_downloads_storage.pvc_name
    }
  ]

  depends_on = [
    module.qbittorrent_config_storage,
    module.qbittorrent_downloads_storage,
    kubernetes_config_map.qbittorrent
  ]
}
