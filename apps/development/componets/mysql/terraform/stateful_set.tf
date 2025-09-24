# apps/mysql/terraform/mysql.tf

module "development_mysql_statefulset" {
  source    = "../../../../../modules/statefulset"
  app_name  = var.mysql_app_name
  image     = var.mysql_image
  namespace = var.namespace
  env_secrets = {
    MYSQL_ROOT_PASSWORD = {
      secret_name = kubernetes_secret.mysql.metadata[0].name
      secret_key  = "mysql-root-password"
    }
  }
  ports = [
    {
      name     = "mysql"
      port     = var.mysql_port
      protocol = "TCP"
    }

  ]
  service_name   = "${var.namespace}-mysql-headless"
  volume_configs = []
  mounts = [
    {
      name       = "mysql-data"
      mount_path = "/var/lib/mysql"
      read_only  = false
    }
  ]
  claims = [
    {
      name       = "mysql-data"
      claim_name = module.mysql_storage.pvc_name
    }
  ]

  depends_on = [
    module.mysql_storage,
    kubernetes_config_map.mysql,
    kubernetes_secret.mysql
  ]
}
