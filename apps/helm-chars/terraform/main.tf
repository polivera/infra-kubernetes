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

module "globals" {
  source = "../../modules/globals"
}

provider "kubernetes" {
  config_path = module.globals.config_path
}

provider "helm" {
  kubernetes {
    config_path = module.globals.config_path
  }
}

# Create base namespaces
resource "kubernetes_namespace" "infrastructure" {
  metadata {
    name = "infrastructure"
  }
}

resource "kubernetes_namespace" "cert_ingress" {
  metadata {
    name = "cert-ingress"
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

# Install nginx-ingress ONCE
resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  namespace  = kubernetes_namespace.cert_ingress.metadata[0].name
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.9.0"

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Install cert-manager ONCE
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  namespace  = kubernetes_namespace.cert_ingress.metadata[0].name
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.14.0"

  set {
    name  = "installCRDs"
    value = "true"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Output to confirm infrastructure is ready
output "infrastructure_ready" {
  value = {
    nfs_csi_ready    = helm_release.nfs_csi_driver.status == "deployed"
    ingress_ready    = helm_release.nginx_ingress.status == "deployed"
    cert_manager_ready = helm_release.cert_manager.status == "deployed"
  }
}