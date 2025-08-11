# Add to your locals block
locals {
  secrets = yamldecode(data.sops_file.secrets.raw)
}

resource "kubernetes_secret" "grafana_admin" {
  metadata {
    name      = "grafana-admin-secret"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  type = "Opaque"

  data = {
    admin-user     = sensitive("admin")
    admin-password = sensitive(local.secrets.grafana_admin_password)
  }
}