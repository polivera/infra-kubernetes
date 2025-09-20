# monitoring/terraform/prometheus.tf
# Install Prometheus
resource "helm_release" "prometheus" {
  count      = local.enable_prometheus
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

      # Add GPU metrics scraping configuration
      extraScrapeConfigs = <<-EOT
          # Scrape GPU metrics from existing DCGM exporter in gpu-operator namespace
          - job_name: 'dcgm-exporter'
            kubernetes_sd_configs:
              - role: pod
                namespaces:
                  names:
                    - gpu-operator
            relabel_configs:
              # Only scrape pods with the DCGM exporter label
              - source_labels: [__meta_kubernetes_pod_label_app_kubernetes_io_name]
                action: keep
                regex: nvidia-dcgm-exporter
              # Use pod IP and port 9400
              - source_labels: [__meta_kubernetes_pod_ip]
                target_label: __address__
                replacement: '${1}:9400'
              # Add helpful labels
              - source_labels: [__meta_kubernetes_pod_node_name]
                target_label: node
              - source_labels: [__meta_kubernetes_namespace]
                target_label: kubernetes_namespace
            scrape_interval: 15s
            metrics_path: /metrics
        EOT
    })
  ]

  depends_on = [
    kubernetes_namespace.monitoring,
    module.prometheus_storage
  ]
}

resource "kubernetes_manifest" "dcgm_service_monitor" {
  count = 0 # Set to 1 if you want to use ServiceMonitor instead

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "dcgm-exporter"
      namespace = kubernetes_namespace.monitoring.metadata[0].name
      labels = {
        app = "dcgm-exporter"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          "app.kubernetes.io/name" = "nvidia-dcgm-exporter"
        }
      }
      namespaceSelector = {
        matchNames = ["gpu-operator"]
      }
      endpoints = [
        {
          port     = "metrics"
          interval = "15s"
          path     = "/metrics"
        }
      ]
    }
  }
}