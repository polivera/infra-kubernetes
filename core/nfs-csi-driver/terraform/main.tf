terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.35.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.2"
    }
  }
}

resource "kubernetes_namespace" "infrastructure" {
  metadata {
    name = "infrastructure"
  }
}

module "globals" {
  source = "../../../modules/globals"
}

provider "kubernetes" {
  config_path = module.globals.config_path
}

provider "helm" {
  kubernetes = {
    config_path = module.globals.config_path
  }
}

# Install NFS CSI Driver ONCE
resource "helm_release" "nfs_csi_driver" {
  name       = "csi-driver-nfs"
  namespace  = kubernetes_namespace.infrastructure.metadata[0].name
  repository = "https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts"
  chart      = "csi-driver-nfs"
  version    = "v4.5.0"

  # Prevent accidental deletion
  lifecycle {
    prevent_destroy = true
  }
}