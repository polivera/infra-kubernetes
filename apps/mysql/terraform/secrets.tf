# apps/mysql/terraform/secrets.tf
locals {
  secrets = yamldecode(data.sops_file.secrets.raw)
}

resource "kubernetes_secret" "mysql" {
  metadata {
    name      = "mysql-secrets"
    namespace = var.namespace
  }
  type = "Opaque"
  data = {
    mysql-root-password = sensitive(local.secrets.mysql_root_password)
    mysql-user          = sensitive(local.secrets.mysql_user)
    mysql-password      = sensitive(local.secrets.mysql_password)
  }
}