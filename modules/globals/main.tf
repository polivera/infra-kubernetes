# ============================================
# modules/globals/main.tf
# ============================================
locals {
  config_file = "~/.kube/config"
  sops_file = "../secrets.enc.yaml"

  domain      = "vicugna.party"
  nfs_server  = "192.168.0.11"
  timezone    = "Europe/Madrid"
}
