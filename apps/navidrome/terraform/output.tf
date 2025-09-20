# apps/navidrome/terraform/outputs.tf
output "app_url" {
  value       = "https://${local.app_url}"
  description = "URL to access Navidrome"
}

output "namespace" {
  value       = var.namespace
  description = "Kubernetes namespace"
}
