# monitoring/terraform/grafana.tf
# Install Grafana
resource "helm_release" "grafana" {
  count      = local.enable_grafana
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "8.5.2"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  values = [
    yamlencode({
      persistence = {
        enabled       = true
        existingClaim = module.grafana_storage[0].pvc_name
      }

      admin = {
        existingSecret = kubernetes_secret.grafana_admin.metadata[0].name
        userKey        = "admin-user"
        passwordKey    = "admin-password"
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

      # Pre-configure Prometheus datasource
      datasources = {
        "datasources.yaml" = {
          apiVersion = 1
          datasources = [
            {
              name      = "Prometheus"
              type      = "prometheus"
              url       = "http://prometheus-server:80"
              access    = "proxy"
              isDefault = true
            }
          ]
        }
      }
    })
  ]

  depends_on = [
    kubernetes_namespace.monitoring,
    kubernetes_secret.grafana_admin,
    module.grafana_storage
  ]
}
