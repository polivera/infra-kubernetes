# Kube-Prometheus-Stack (includes Prometheus, Grafana, AlertManager, and exporters)
resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "76.2.0"  # Check for latest version
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  values = [
    yamlencode({
      # Prometheus configuration
      prometheus = {
        prometheusSpec = {
          storageSpec = {
            volumeClaimTemplate = {
              spec = {
                storageClassName = "fast"
                accessModes      = ["ReadWriteOnce"]
                resources = {
                  requests = {
                    storage = var.prometheus_storage_size
                  }
                }
              }
            }
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
      }

      # Grafana configuration
      grafana = {
        persistence = {
          enabled = true
          storageClassName = "fast"
          size = var.grafana_storage_size
        }
        admin = {
          existingSecret = kubernetes_secret.grafana_admin.metadata[0].name
          userKey = "admin-user"
          passwordKey = "admin-password"
        }
        service = {
          type = "ClusterIP"
        }
        resources = {
          requests = {
            memory = var.grafana_memory_request
            cpu    = var.grafana_cpu_request
          }
          limits = {
            memory = var.grafana_memory_limit
            cpu    = var.grafana_cpu_limit
          }
        }
        # Pre-configured dashboards
        dashboardProviders = {
          "dashboardproviders.yaml" = {
            apiVersion = 1
            providers = [
              {
                name    = "default"
                orgId   = 1
                folder  = ""
                type    = "file"
                options = {
                  path = "/var/lib/grafana/dashboards/default"
                }
              }
            ]
          }
        }
      }

      # AlertManager configuration
      alertmanager = {
        alertmanagerSpec = {
          storage = {
            volumeClaimTemplate = {
              spec = {
                storageClassName = "fast"
                accessModes      = ["ReadWriteOnce"]
                resources = {
                  requests = {
                    storage = "5Gi"
                  }
                }
              }
            }
          }
        }
      }

      # Node Exporter configuration
      nodeExporter = {
        enabled = true
      }

      # kube-state-metrics configuration
      kubeStateMetrics = {
        enabled = true
      }

      # Disable components you don't need
      kubeEtcd = {
        enabled = false  # Usually not accessible in managed clusters
      }
      kubeControllerManager = {
        enabled = false  # Usually not accessible in managed clusters
      }
      kubeScheduler = {
        enabled = false  # Usually not accessible in managed clusters
      }
    })
  ]

  depends_on = [
    kubernetes_namespace.monitoring,
    kubernetes_secret.grafana_admin,
    module.prometheus_storage,
    kubernetes_persistent_volume.grafana
  ]
}

# Loki for log aggregation
resource "helm_release" "loki" {
  name       = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  version    = "6.35.1"  # Check for latest version
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  values = [
    yamlencode({
      deploymentMode = "SingleBinary"

      loki = {
        auth_enabled = false
        commonConfig = {
          replication_factor = 1
        }
        storage = {
          type = "filesystem"
        }
        schemaConfig = {
          configs = [
            {
              from         = "2024-04-01"
              store        = "tsdb"
              object_store = "filesystem"
              schema       = "v13"
              index = {
                prefix = "index_"
                period = "24h"
              }
            }
          ]
        }
      }

      singleBinary = {
        replicas = 1
        persistence = {
          enabled          = true
          storageClassName = "slow"
          size             = var.loki_storage_size
        }
        resources = {
          requests = {
            memory = var.loki_memory_request
            cpu    = var.loki_cpu_request
          }
          limits = {
            memory = var.loki_memory_limit
            cpu    = var.loki_cpu_limit
          }
        }
      }

      # Disable other modes
      write = {
        replicas = 0
      }
      read = {
        replicas = 0
      }
      backend = {
        replicas = 0
      }
    })
  ]

  depends_on = [
    kubernetes_namespace.monitoring,
    module.loki_storage
  ]
}

# Grafana Alloy for log collection
resource "helm_release" "alloy" {
  name       = "alloy"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "alloy"
  version    = "1.2.1"  # Check for latest version
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  values = [
    yamlencode({
      alloy = {
        configMap = {
          create = true
          content = <<-EOT
            logging {
              level  = "info"
              format = "logfmt"
            }

            discovery.kubernetes "pods" {
              role = "pod"
            }

            discovery.kubernetes "nodes" {
              role = "node"
            }

            loki.source.kubernetes "pods" {
              targets    = discovery.kubernetes.pods.targets
              forward_to = [loki.write.default.receiver]
            }

            loki.source.journal "system" {
              forward_to = [loki.write.default.receiver]
              labels     = {
                job = "systemd-journal",
              }
            }

            loki.write "default" {
              endpoint {
                url = "http://loki:3100/loki/api/v1/push"
              }
            }
          EOT
        }
      }

      controller = {
        type = "daemonset"
      }

      serviceAccount = {
        create = true
      }

      resources = {
        requests = {
          memory = "128Mi"
          cpu    = "100m"
        }
        limits = {
          memory = "512Mi"
          cpu    = "500m"
        }
      }

      tolerations = [
        {
          operator = "Exists"
        }
      ]
    })
  ]

  depends_on = [
    helm_release.loki
  ]
}