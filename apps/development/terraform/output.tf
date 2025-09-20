# apps/development/terraform/outputs.tf

output "postgres_connection_info" {
  description = "PostgreSQL connection information"
  value = {
    external_ip   = var.postgres_external_ip
    internal_host = "postgres-dev.development.svc.cluster.local"
    port          = var.postgres_port
  }
}

output "redis_connection_info" {
  description = "Redis connection information"
  value = {
    external_ip   = var.redis_external_ip
    internal_host = "redis-dev.development.svc.cluster.local"
    port          = var.redis_port
  }
}

output "development_ready" {
  description = "Development environment status"
  value = {
    namespace_created = kubernetes_namespace.development.metadata[0].name
    postgres_deployed = kubernetes_stateful_set.postgres_dev.metadata[0].name
    redis_deployed    = kubernetes_stateful_set.redis_dev.metadata[0].name
  }
}