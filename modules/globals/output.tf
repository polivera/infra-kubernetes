# ============================================
# modules/globals/main.tf
# ============================================
output "domain" {
  value = local.domain
}

output "nfs_server" {
  value = local.nfs_server
}

output "timezone" {
  value = local.timezone
}

output "config_path" {
  value = local.config_file
}

output "sops_file_path" {
  value = local.sops_file
}

output "ingress_namespace" {
  value = local.ingress_namespace
}

output "cert_secret_name" {
  value = local.cert_secret_name
}

output "dns_nameservers" {
  value = local.dns_nameservers
}

output "dns_searches" {
  value = local.dns_searches
}