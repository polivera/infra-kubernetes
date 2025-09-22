# Gitea StatefulSet
module "gitea_stateful_set" {
  source         = "../../../modules/statefulset"
  app_name       = var.namespace
  namespace      = var.namespace
  service_name   = "${var.namespace}-headless"
  image          = var.image
  request_cpu    = var.request_cpu
  request_memory = var.request_memory
  limit_cpu      = var.limit_cpu
  limit_memory   = var.limit_memory
  envs = {
    USER_UID = {
      value = "1000"
    },
    USER_GID = {
      value = "1000"
    }
  }
  env_secrets = {
    GITEA__database__PASSWD = {
      secret_name = kubernetes_secret.gitea.metadata[0].name
      secret_key  = "database-password"
    },
    GITEA__security__SECRET_KEY = {
      secret_name = kubernetes_secret.gitea.metadata[0].name
      secret_key  = "secret-key"
    }
  }
  ports = [
    {
      port     = var.http_port
      name     = "http"
      protocol = "TCP"
    },
    {
      port     = var.ssh_port
      name     = "ssh"
      protocol = "TCP"
    }
  ]
  mounts = [
    {
      name       = "gitea-data"
      mount_path = "/data"
      read_only  = false
    },
    {
      name       = "gitea-config"
      mount_path = "/etc/gitea"
      read_only  = false
    }
  ]
  claims = [
    {
      name       = "gitea-data"
      claim_name = module.gitea_storage.pvc_name
    }
  ]
  volume_configs = [
    {
      name        = "gitea-config",
      config_name = kubernetes_config_map.gitea.metadata[0].name
    }
  ]

  depends_on = [
    module.gitea_storage,
    kubernetes_config_map.gitea,
    kubernetes_secret.gitea
  ]
}
