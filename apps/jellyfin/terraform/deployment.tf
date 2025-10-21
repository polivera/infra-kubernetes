# Jellyfin deployment
module "jellyfin_deployment" {
  source = "../../../modules/deployment"

  app_name          = var.namespace
  image             = var.image
  namespace         = var.namespace
  request_cpu       = var.request_cpu
  request_memory    = var.request_memory
  limit_cpu         = var.limit_cpu
  limit_memory      = var.limit_memory
  gpu_node_hostname = "zeratul"
  envs = {
    JELLYFIN_PublishedServerUrl = {
      value = "https://${var.hostname}"
    }
  }
  ports = [
    {
      name     = "http"
      port     = var.port
      protocol = "TCP"
    }
  ]
  mounts = [
    {
      name       = "jellyfin-config"
      mount_path = "/config"
      read_only  = false
    },
    {
      name       = "jellyfin-cache"
      mount_path = "/cache"
      read_only  = false
    },
    {
      name       = "jellyfin-movies"
      mount_path = "/movies"
      read_only  = true
    },
    {
      name       = "jellyfin-anime"
      mount_path = "/anime"
      read_only  = true
    }
  ]
  claims = [
    {
      name       = "jellyfin-config"
      claim_name = module.jellyfin_config_storage.pvc_name
    },
    {
      name       = "jellyfin-cache"
      claim_name = module.jellyfin_cache_storage.pvc_name
    },
    {
      name = "jellyfin-movies"
      claim_name = module.jellyfin_movies_storage.pvc_name
    },
    {
      name = "jellyfin-anime"
      claim_name = module.jellyfin_anime_storage.pvc_name
    }
  ]

  depends_on = [
    module.jellyfin_movies_storage,
    module.jellyfin_anime_storage,
  ]
}
