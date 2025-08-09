# ============================================
# modules/globals/main.tf
# ============================================
locals {
  config_file       = "~/.kube/config"
  sops_file         = "../secrets.enc.yaml"
  timezone          = "Europe/Madrid"
  ingress_namespace = "cert-ingress"
  domain            = "vicugna.party"
  cert_secret_name  = "vicugna-party-wildcard-tls"
  nfs_server        = "192.168.0.11"
}
