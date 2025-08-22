# apps/valkey/terraform/config.tf
resource "kubernetes_config_map" "valkey" {
  metadata {
    name      = "valkey-config"
    namespace = kubernetes_namespace.valkey.metadata[0].name
  }

  data = {
    "valkey.conf" = <<-EOF
      # Valkey configuration
      bind 0.0.0.0
      port ${var.port}

      # Persistence
      save 900 1
      save 300 10
      save 60 10000

      # Logging
      loglevel notice
      logfile ""

      # Memory management
      maxmemory-policy allkeys-lru

      # Security
      ${var.password != "" ? "requirepass ${var.password}" : "# No password set"}

      # Append only file
      appendonly yes
      appendfilename "appendonly.aof"
      appendfsync everysec

      # Disable dangerous commands in production
      # rename-command FLUSHDB ""
      # rename-command FLUSHALL ""
      # rename-command CONFIG ""
      # rename-command DEBUG ""
    EOF
  }
}
