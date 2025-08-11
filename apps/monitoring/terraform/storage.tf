# Storage for Prometheus data
module "prometheus_storage" {
  count      = local.enable_prometheus
  source     = "../../../modules/static-nfs-volume"
  app_name   = "prometheus"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  size       = var.prometheus_storage_size
  pool       = "fast"
  force_path = "Monitoring/prometheus"
}

# Storage for Loki data
module "loki_storage" {
  count      = local.enable_loki
  source     = "../../../modules/static-nfs-volume"
  app_name   = "loki"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  size       = var.loki_storage_size
  pool       = "fast"
  force_path = "Monitoring/loki"
}

module "grafana_storage" {
  count      = local.enable_grafana
  source     = "../../../modules/static-nfs-volume"
  app_name   = "grafana"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  size       = var.grafana_storage_size
  pool       = "fast"
  force_path = "Monitoring/grafana"
}
