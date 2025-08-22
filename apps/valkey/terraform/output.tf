# apps/valkey/terraform/outputs.tf
output "service_name" {
  description = "Name of the Valkey service"
  value       = kubernetes_stateful_set.valkey.metadata[0].name
}

output "service_port" {
  description = "Port of the Valkey service"
  value       = var.port
}

output "namespace" {
  description = "Namespace where Valkey is deployed"
  value       = kubernetes_namespace.valkey.metadata[0].name
}

output "connection_string" {
  description = "Connection string for Valkey"
  value       = "valkey://${kubernetes_stateful_set.valkey.metadata[0].name}.${kubernetes_namespace.valkey.metadata[0].name}.svc.cluster.local:${var.port}"
}