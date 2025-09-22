# apps/mysql/terraform/mysql.tf
# MySQL StatefulSet

module "mysql_stateful_set" {
  source         = "../../../modules/statefulset"
  app_name       = var.namespace
  image          = var.image
  namespace      = var.namespace
  service_name   = "${var.namespace}-headless"
  request_cpu    = var.request_cpu
  request_memory = var.request_memory
  limit_cpu      = var.limit_cpu
  limit_memory   = var.limit_memory
  command_probe = [
    "mysqladmin",
    "ping",
    "-h",
    "localhost",
    "-u",
    "root",
    "-p$${MYSQL_ROOT_PASSWORD}"
  ]

  env_secrets = {
    MYSQL_ROOT_PASSWORD = {
      secret_name = kubernetes_secret.mysql.metadata[0].name
      secret_key  = "mysql-root-password"
    },
  }

  ports = [
    {
      port     = var.port
      name     = "mysql"
      protocol = "TCP"
    }
  ]
  mounts = [
    {
      name       = "mysql-data"
      mount_path = "/var/lib/mysql"
      read_only  = false
    },
    {
      name       = "mysql-config"
      mount_path = "/etc/mysql/conf.d"
      read_only  = false
    }
  ]
  claims = [
    {
      name       = "mysql-data"
      claim_name = module.mysql_storage.pvc_name
    }
  ]
  volume_configs = [
    {
      name        = "mysql-config"
      config_name = kubernetes_config_map.mysql.metadata[0].name
      items = {
        key  = "my_cnf"
        path = "my.cnf"
      }
    }
  ]

  depends_on = [
    module.mysql_storage,
    kubernetes_config_map.mysql,
    kubernetes_secret.mysql
  ]
}
