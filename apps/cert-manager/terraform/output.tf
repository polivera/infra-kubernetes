output "wildcard_cert_secret" {
  description = "Name of the wildcard certificate secret to use in ingresses"
  value       = var.certificate_secret_name
}

output "cert_namespace" {
  description = "Namespace where the certificate is stored"
  value       = var.cert_namespace
}

output "cluster_issuer_name" {
  description = "Name of the ClusterIssuer for other certificates"
  value       = var.cluster_issuer_name
}

output "certificate_info" {
  description = "Certificate information for ingress configuration"
  value = {
    secret_name = var.certificate_secret_name
    namespace   = var.cert_namespace
    dns_names   = var.dns_names
  }
}