# monitoring/terraform/prometheus.tf
# Install Prometheus
resource "helm_release" "prometheus" {
  count = local.enable_prometheus
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "27.29.1"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  values = [
    yamlencode({
      server = {
        persistentVolume = {
          enabled       = true
          existingClaim = module.prometheus_storage[0].pvc_name
          mountPath     = "/prometheus"
        }
        retention = "30d"
        resources = {
          requests = {
            memory = var.prometheus_memory_request
            cpu    = var.prometheus_cpu_request
          }
          limits = {
            memory = var.prometheus_memory_limit
            cpu    = var.prometheus_cpu_limit
          }
        }
      }

      # Enable node exporter
      nodeExporter = {
        enabled = true
      }

      # Enable kube-state-metrics
      kubeStateMetrics = {
        enabled = true
      }

      # Disable alertmanager (we'll add it separately if needed)
      alertmanager = {
        enabled = false
      }
    })
  ]

  depends_on = [
    kubernetes_namespace.monitoring,
    module.prometheus_storage
  ]
}
