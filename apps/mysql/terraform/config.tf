# apps/mysql/terraform/config.tf
resource "kubernetes_config_map" "mysql" {
  metadata {
    name      = "mysql-config"
    namespace = var.namespace
  }
  data = {
    MYSQL_DATABASE = "myapp"
    # Custom MySQL configuration
    my_cnf = <<-EOF
      [mysqld]
      # Basic settings
      default-storage-engine = innodb
      default_authentication_plugin = mysql_native_password

      # Character set and collation
      character-set-server = utf8mb4
      collation-server = utf8mb4_unicode_ci

      # InnoDB settings
      innodb_buffer_pool_size = 1G
      innodb_file_per_table = 1
      innodb_flush_log_at_trx_commit = 2
      innodb_flush_method = O_DIRECT

      # Connection settings
      max_connections = 200
      max_connect_errors = 100000

      # Query cache
      query_cache_type = 1
      query_cache_size = 64M

      # Logging
      slow_query_log = 1
      slow_query_log_file = /var/lib/mysql/slow.log
      long_query_time = 2

      # Binary logging for replication (optional)
      log-bin = mysql-bin
      server-id = 1

      # Security
      local-infile = 0
    EOF
  }
}