# apps/homeassistant/terraform/config.tf
resource "kubernetes_config_map" "homeassistant" {
  metadata {
    name      = "homeassistant-config"
    namespace = var.namespace
  }

  data = {
    TZ = module.globals.timezone
  }
}
