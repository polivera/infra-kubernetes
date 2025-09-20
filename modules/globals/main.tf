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

  # DNS Configuration - Confirmed from kubectl get svc -n kube-system
  cluster_dns     = "10.43.0.10"  # K3s kube-dns service IP
  external_dns    = "192.168.0.1" # Your router/external DNS
  dns_nameservers = [local.cluster_dns, local.external_dns]
  dns_searches    = ["svc.cluster.local", "cluster.local"]
}
