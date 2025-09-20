# Ingress for Grafana
module "grafana_ingress" {
  count  = local.enable_grafana
  source = "../../../modules/ingress"

  cert_secret       = module.globals.cert_secret_name
  external_name     = "grafana.monitoring.svc.cluster.local"
  hostname          = "grafana.${module.globals.domain}"
  ingress_name      = "grafana-ingress"
  ingress_namespace = module.globals.ingress_namespace
  port              = 80

  depends_on = [
    helm_release.grafana
  ]
}

# Optional: Ingress for Prometheus
module "prometheus_ingress" {
  count  = local.enable_prometheus
  source = "../../../modules/ingress"

  cert_secret       = module.globals.cert_secret_name
  external_name     = "prometheus-server.monitoring.svc.cluster.local"
  hostname          = "prometheus.${module.globals.domain}"
  ingress_name      = "prometheus-ingress"
  ingress_namespace = module.globals.ingress_namespace
  port              = 80

  depends_on = [
    helm_release.prometheus
  ]
}
