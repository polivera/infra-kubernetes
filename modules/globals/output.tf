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