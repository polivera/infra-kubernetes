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

      # Performance Schema (replaces query cache functionality)
      performance_schema = ON
      performance_schema_consumer_events_statements_current = ON
      performance_schema_consumer_events_statements_history = ON
      performance_schema_consumer_events_statements_history_long = ON

      # Logging
      slow_query_log = 1
      slow_query_log_file = /var/lib/mysql/slow.log
      long_query_time = 2

      # Binary logging for replication (optional)
      log-bin = mysql-bin
      server-id = 1

      # Security
      local-infile = 0

      # MySQL 8.0 specific optimizations
      # Better join optimization
      optimizer_switch = 'index_merge=on,index_merge_union=on,index_merge_sort_union=on,index_merge_intersection=on,engine_condition_pushdown=on,index_condition_pushdown=on,mrr=on,mrr_cost_based=on,block_nested_loop=on,batched_key_access=off,materialization=on,semijoin=on,loosescan=on,firstmatch=on,duplicateweedout=on,subquery_materialization_cost_based=on,use_index_extensions=on,condition_fanout_filter=on,derived_merge=on,use_invisible_indexes=off,skip_scan=on,hash_join=on'

      # Adaptive hash index (InnoDB)
      innodb_adaptive_hash_index = ON

      # Parallel query execution (MySQL 8.0.14+)
      innodb_parallel_read_threads = 4
    EOF
  }
}