# apps/valkey/terraform/valkey.tf
module "valley_stateful_set" {
  source         = "../../../modules/statefulset"
  app_name       = var.namespace
  image          = var.image
  namespace      = var.namespace
  request_memory = var.request_memory
  request_cpu    = var.request_cpu
  limit_memory   = var.limit_memory
  limit_cpu      = var.limit_cpu

  command_start = ["valkey-server", "/usr/local/etc/valkey/valkey.conf"]
  tcp_probe = var.port

  ports = [{
    name     = var.namespace
    port     = var.port
    protocol = "TCP"
  }]
  service_name = "${var.namespace}-headless"
  mounts = [
    {
      name       = "valkey-data",
      mount_path = "/data"
      read_only  = false
    },
    {
      name       = "valkey-config"
      mount_path = "/usr/local/etc/valkey"
      read_only  = true
    }
  ]
  claims = [
    {
      name       = "valkey-data"
      claim_name = module.valkey_storage.pvc_name
    }
  ]
  volume_configs = [
    {
      name        = "valkey-config"
      config_name = kubernetes_config_map.valkey.metadata[0].name
      items = {
        key  = "valkey.conf"
        path = "valkey.conf"
      }
    }
  ]

  depends_on = [
    module.valkey_storage,
    kubernetes_config_map.valkey
  ]
}
