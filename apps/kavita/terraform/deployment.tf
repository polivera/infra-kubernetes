# apps/kavita/terraform/kavita.tf
# Kavita Deployment
module "kavita_deployment" {
  source    = "../../../modules/deployment"
  app_name  = var.namespace
  image     = var.image
  namespace = var.namespace
  ports = [
    {
      port     = var.port
      name     = "standar"
      protocol = "TCP"
    }
  ]
  request_cpu = var.request_cpu
  request_memory = var.request_memory
  limit_cpu = var.limit_cpu
  limit_memory = var.limit_memory
  http_probe = "/"
  http_probe_port = var.port
  envs = {
    TZ = {
      value = module.globals.timezone
    }
  }
  mounts = [
    {
      name = "kavita-config"
      mount_path = "/kavita/config"
      read_only = false
    },
    {
      name = "kavita-media"
      mount_path = "/books"
      read_only = false
    }
  ]
  claims = [
    {
      name  = "kavita-config"
      claim_name = module.kavita_config_storage.pvc_name
    },
    {
      name  = "kavita-media"
      claim_name = module.kavita_media_storage.pvc_name
    }
  ]
  depends_on = [
    module.kavita_config_storage,
    module.kavita_media_storage
  ]
}
