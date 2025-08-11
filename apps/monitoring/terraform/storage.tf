# Storage for Prometheus data
module "prometheus_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "prometheus"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  size       = var.prometheus_storage_size
  pool       = "fast"
  force_path = "Monitoring/prometheus"
}

# Storage for Loki data
module "loki_storage" {
  source     = "../../../modules/static-nfs-volume"
  app_name   = "loki"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  size       = var.loki_storage_size
  pool       = "fast"
  force_path = "Monitoring/loki"
}

# Static PV using CSI driver
resource "kubernetes_persistent_volume" "grafana" {
  metadata {
    name = "grafana-fast-pv"
    labels = {
      app  = "grafana"
      pool = "fast"
      type = "static-nfs"
    }
  }

  spec {
    capacity = {
      storage = var.grafana_storage_size
    }

    access_modes       = ["ReadWriteMany"]
    storage_class_name = "fast"

    persistent_volume_source {
      csi {
        driver        = "nfs.csi.k8s.io"
        volume_handle = "grafana-fast-${var.namespace}"

        volume_attributes = {
          server = "192.168.0.11"
          share  = "/mnt/FastPool/Monitoring/grafana"
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
