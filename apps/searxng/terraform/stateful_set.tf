# apps/searxng/terraform/searxng.tf
module "searxng_stateful_set" {
  source       = "../../../modules/statefulset"
  app_name     = var.namespace
  namespace    = var.namespace
  image        = var.image
  service_name = var.namespace

  request_cpu    = var.request_cpu
  request_memory = var.request_memory
  limit_cpu      = var.limit_cpu
  limit_memory   = var.limit_memory

  http_probe      = "/healthz"
  http_probe_port = var.port

  ports = [
    {
      name     = var.namespace
      port     = var.port
      protocol = "TCP"
    }
  ]
  mounts = [
    {
      name       = "searxng-config"
      mount_path = "/etc/searxng"
      read_only  = false
    },
    {
      name       = "searxng-cache"
      mount_path = "/var/cache/searxng"
      read_only  = false
    }
  ]
  claims = [
    {
      name       = "searxng-config"
      claim_name = module.searxng_config_storage.pvc_name
    },
    {
      name       = "searxng-cache"
      claim_name = module.searxng_cache_storage.pvc_name
    }
  ]
  volume_configs = []
}
