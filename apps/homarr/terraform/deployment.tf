# Deployment

module "homarr_deployment" {
  source         = "../../../modules/deployment"
  namespace      = var.namespace
  app_name       = var.namespace
  image          = var.image
  request_cpu    = var.request_cpu
  request_memory = var.request_memory
  limit_cpu      = var.limit_cpu
  limit_memory   = var.limit_memory

  tcp_probe = var.port

  envs = {
    NODE_ENV = {
      value = "production"
    }
  }

  env_secrets = {
    SECRET_ENCRYPTION_KEY = {
      secret_name = kubernetes_secret.homarr.metadata[0].name
      secret_key  = "secret-encryption-key"
    }
  }

  ports = [
    {
      name     = var.namespace
      port     = var.port
      protocol = "TCP"
    }
  ]

  mounts = [
    {
      name       = "homarr-data"
      mount_path = "/appdata"
      read_only  = false
    }
  ]

  claims = [
    {
      name       = "homarr-data"
      claim_name = module.homarr_storage.pvc_name
    }
  ]

  security_context = {
    fs_group = 1000
  }

  depends_on = [
    module.homarr_storage.pvc_name
  ]
}
