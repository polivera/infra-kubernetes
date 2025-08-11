# Grafana Alloy for log collection
resource "helm_release" "alloy" {
  count      = local.enable_loki
  name       = "alloy"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "alloy"
  version    = "1.2.1" # Check for latest version
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  values = [
    yamlencode({
      alloy = {
        configMap = {
          create  = true
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
