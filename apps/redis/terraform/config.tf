# apps/redis/terraform/config.tf
resource "kubernetes_config_map" "redis" {
  metadata {
    name      = "redis-config"
    namespace = var.namespace
  }
  data = {
    redis_conf = <<-EOF
      # Redis configuration
      save 900 1
      save 300 10
      save 60 10000
      dir /data
      appendonly yes
      appendfsync everysec
      # Disable protected mode for cluster access
      protected-mode no
      # Bind to all interfaces for cluster access
      bind 0.0.0.0
    EOF
  }
}
