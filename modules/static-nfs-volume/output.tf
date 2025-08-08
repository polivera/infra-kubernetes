# ============================================
# modules/static-nfs-volume/outputs.tf
# ============================================
output "pvc_name" {
  description = "Name of the PVC to use in pod specs"
  value       = kubernetes_persistent_volume_claim.this.metadata[0].name
}

output "pv_name" {
  description = "Name of the PV"
  value       = kubernetes_persistent_volume.this.metadata[0].name
}

output "nfs_path" {
  description = "Full NFS path for reference"
  value       = local.nfs_path
}