# ============================================
# modules/static-nfs-volume/main.tf
# ============================================
locals {
  pool_paths = {
    slow = "/mnt/SlowPool"
    fast = "/mnt/FastPool"
  }

  # Capitalize app name for folder (matching your Docker setup)
  app_folder = title(var.app_name)

  # Build full path
  sub_path = var.subpath != "" ? "${local.pool_paths[var.pool]}/${local.app_folder}/${var.subpath}" : "${local.pool_paths[var.pool]}/${local.app_folder}"
  force_path = var.force_path != "" ? "${local.pool_paths[var.pool]}/${var.force_path}" : ""
  nfs_path = local.force_path != "" ? local.force_path : local.sub_path

  # Consistent naming convention
  pv_name  = "${var.app_name}-${var.pool}-pv"
  pvc_name = "${var.app_name}-data"
}

# Static PV using CSI driver
resource "kubernetes_persistent_volume" "this" {
  metadata {
    name = local.pv_name
    labels = {
      app  = var.app_name
      pool = var.pool
      type = "static-nfs"
    }
  }

  spec {
    capacity = {
      storage = var.size
    }

    access_modes       = var.access_modes
    storage_class_name = "" # Empty for static provisioning

    persistent_volume_source {
      csi {
        driver        = "nfs.csi.k8s.io"
        volume_handle = "${var.app_name}-${var.pool}-${var.namespace}"

        volume_attributes = {
          server = var.nfs_server
          share  = local.nfs_path
        }
      }
    }

    persistent_volume_reclaim_policy = "Retain"
  }

  lifecycle {
    # Prevent accidental deletion of PV (data protection)
    prevent_destroy = false # Set to true in production
  }
}

# PVC that binds to the static PV
resource "kubernetes_persistent_volume_claim" "this" {
  metadata {
    name      = local.pvc_name
    namespace = var.namespace
  }

  spec {
    access_modes       = var.access_modes
    storage_class_name = "" # Must match PV
    volume_name        = kubernetes_persistent_volume.this.metadata[0].name

    resources {
      requests = {
        storage = var.size
      }
    }
  }

  # Wait for PV to be ready
  depends_on = [kubernetes_persistent_volume.this]
}
