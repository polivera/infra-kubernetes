# Ingress for Grafana
module "grafana_ingress" {
  source = "../../../modules/ingress"

  cert_secret       = module.globals.cert_secret_name
  external_name     = "kube-prometheus-stack-grafana.monitoring.svc.cluster.local"
  hostname          = "grafana.${module.globals.domain}"
  ingress_name      = "grafana-ingress"
  ingress_namespace = module.globals.ingress_namespace
  port              = 80

  depends_on = [
    helm_release.kube_prometheus_stack
  ]
}

# Optional: Ingress for Prometheus
module "prometheus_ingress" {
  source = "../../../modules/ingress"

  cert_secret       = module.globals.cert_secret_name
  external_name     = "kube-prometheus-stack-prometheus.monitoring.svc.cluster.local"
  hostname          = "prometheus.${module.globals.domain}"
  ingress_name      = "prometheus-ingress"
  ingress_namespace = module.globals.ingress_namespace
  port              = 9090

  depends_on = [
    helm_release.kube_prometheus_stack
  ]
}
