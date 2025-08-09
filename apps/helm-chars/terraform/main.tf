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
  # lifecycle {
  #   prevent_destroy = true
  # }
}

# Install nginx-ingress ONCE
resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  namespace  = kubernetes_namespace.cert_ingress.metadata[0].name
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.9.0"

  set = [
    {
      name  = "controller.service.type"
      value = "LoadBalancer"
    }
  ]
  #
  # lifecycle {
  #   prevent_destroy = true
  # }
}

# Install cert-manager ONCE
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  namespace  = kubernetes_namespace.cert_ingress.metadata[0].name
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.14.0"

  set = [
    {
      name  = "installCRDs"
      value = "true"
    }
  ]

  values = [
    yamlencode({
      podDnsPolicy = "None"
      podDnsConfig = {
        nameservers = [var.cluster_dns, var.external_dns]
        searches = [
          "cert-manager.svc.cluster.local",
          "svc.cluster.local",
          "cluster.local"
        ]
        options = [
          {
            name  = "ndots"
            value = "2"
          },
          {
            name = "edns0"
          }
        ]
      }
      # Use external DNS for propagation checks
      extraArgs = [
        "--dns01-recursive-nameservers=1.1.1.1:53,8.8.8.8:53",
        "--dns01-recursive-nameservers-only",
        "--v=4" # Add verbose logging
      ]
    })
  ]
  # lifecycle {
  #   prevent_destroy = true
  # }
}

# Add these variables to your helm-chars variables or use directly
variable "cluster_dns" {
  description = "Cluster DNS server IP"
  type        = string
  default     = "10.96.0.10" # Default kube-dns/coredns service IP
}

variable "external_dns" {
  description = "External DNS server for propagation checks"
  type        = string
  default     = "192.168.0.1"
}

# Output to confirm infrastructure is ready
output "infrastructure_ready" {
  value = {
    nfs_csi_ready      = helm_release.nfs_csi_driver.status == "deployed"
    ingress_ready      = helm_release.nginx_ingress.status == "deployed"
    cert_manager_ready = helm_release.cert_manager.status == "deployed"
  }
}
