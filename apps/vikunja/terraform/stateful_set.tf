module "vikunja_stateful_set" {
  source       = "../../../modules/statefulset"
  namespace    = var.namespace
  app_name     = var.namespace
  image        = var.image
  service_name = var.namespace

  request_cpu    = var.request_cpu
  request_memory = var.request_memory
  limit_cpu      = var.limit_cpu
  limit_memory   = var.limit_memory

  env_configs = {
    VIKUNJA_DATABASE_HOST = {
      config_name = kubernetes_config_map.vikunja.metadata[0].name
      config_key  = "VIKUNJA_DATABASE_HOST"
    },
    VIKUNJA_SERVICE_PUBLICURL = {
      config_name = kubernetes_config_map.vikunja.metadata[0].name
      config_key  = "VIKUNJA_SERVICE_PUBLICURL"
    },
    VIKUNJA_DATABASE_TYPE = {
      config_name = kubernetes_config_map.vikunja.metadata[0].name
      config_key  = "VIKUNJA_DATABASE_TYPE"
    }
  }
  env_secrets = {
    VIKUNJA_SERVICE_JWTSECRET = {
      secret_name = kubernetes_secret.vikunja.metadata[0].name
      secret_key  = "service-jtw-secret"
      sensitive   = true
    }
    VIKUNJA_DATABASE_USER = {
      secret_name = kubernetes_secret.vikunja.metadata[0].name
      secret_key  = "database-user"
      sensitive   = true
    }
    VIKUNJA_DATABASE_PASSWORD = {
      secret_name = kubernetes_secret.vikunja.metadata[0].name
      secret_key  = "database-password"
      sensitive   = true
    }
    VIKUNJA_DATABASE_DATABASE = {
      secret_name = kubernetes_secret.vikunja.metadata[0].name
      secret_key  = "database-name"
      sensitive   = true
    }
  }
  ports = [
    {
      name     = "web"
      port     = var.port
      protocol = "TCP"
    }
  ]
  mounts = [
    {
      name       = "vikunja-files"
      mount_path = "/app/vikunja/files"
      read_only  = false
    }
  ]
  claims = [
    {
      name       = "vikunja-files"
      claim_name = module.vikunja_storage_files.pvc_name
    }
  ]
  volume_configs = []

  depends_on = [
    module.vikunja_storage_files,
    kubernetes_config_map.vikunja,
    kubernetes_secret.vikunja
  ]
}
