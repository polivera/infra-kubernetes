# apps/searxng/terraform/configmap.tf
resource "kubernetes_config_map" "searxng" {
  metadata {
    name      = "searxng-config"
    namespace = var.namespace
  }

  data = {
    # SearchXNG configuration
    SEARXNG_BASE_URL     = "https://${local.app_url}/"
    SEARXNG_PORT         = tostring(var.port)
    SEARXNG_BIND_ADDRESS = "0.0.0.0"

    # Granian server configuration
    GRANIAN_HOST             = "0.0.0.0"
    GRANIAN_PORT             = tostring(var.port)
    GRANIAN_WORKERS          = tostring(var.granian_workers)
    GRANIAN_INTERFACE        = "wsgi" # Flask needs this for some reason
    GRANIAN_BLOCKING_THREADS = tostring(var.granian_blocking_threads)

    FORCE_OWNERSHIP = "false"
  }
}
