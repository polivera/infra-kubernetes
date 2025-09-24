locals {
  secrets = yamldecode(data.sops_file.secrets.raw)
}

resource "kubernetes_secret" "mysql" {
  metadata {
    name      = "mysql-secrets"
    namespace = data.kubernetes_namespace.mysql.metadata[0].name
  }
  type = "Opaque"
  data = {
    mysql-root-password = sensitive(local.secrets.mysql_root_password)
  }
}
