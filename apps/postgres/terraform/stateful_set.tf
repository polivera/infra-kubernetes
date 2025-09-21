# Postgres StatefulSet
module "postgres_stateful_set" {
  source       = "../../../modules/statefulset"
  namespace    = var.namespace
  service_name = "${var.namespace}-headless"
  app_name     = var.namespace
  image        = var.image
  port         = var.port

  request_cpu    = var.request_cpu
  request_memory = var.request_memory
  limit_cpu      = var.limit_cpu
  limit_memory   = var.limit_memory

  envs = {
    PGDATA = {
      value     = "/var/lib/postgresql/data/pgdata"
      read_only = false
    }
  }

  env_configs = {
    POSTGRES_DB = {
      config_name = kubernetes_config_map.postgres.metadata[0].name
      config_key  = "POSTGRES_DB"
    }
  }
  env_secrets = {
    POSTGRES_USER = {
      secret_name = kubernetes_secret.postgres.metadata[0].name
      secret_key  = "postgres-user"
    }
    POSTGRES_PASSWORD = {
      secret_name = kubernetes_secret.postgres.metadata[0].name
      secret_key  = "postgres-password"
    }
  }

  mounts = [
    {
      name       = "postgres-data"
      mount_path = "/var/lib/postgresql/data"
      read_only  = false
    }
  ]
  claims = [
    {
      name       = "postgres-data"
      claim_name = module.postgres_storage.pvc_name
    }
  ]

  command_probe = [
    "sh",
    "-c",
    "pg_isready -U $POSTGRES_USER -d $POSTGRES_DB"
  ]

  depends_on = [
    module.postgres_storage,
    kubernetes_config_map.postgres,
    kubernetes_secret.postgres
  ]
}
