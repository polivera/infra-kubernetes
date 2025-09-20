terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.35.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.1.1"
    }
  }
}

module "globals" {
  source = "../../../modules/globals"
}

provider "kubernetes" {
  config_path = module.globals.config_path
}

provider "kubectl" {
  config_path = module.globals.config_path
}

# SOPS data source for secrets
data "sops_file" "secrets" {
  source_file = module.globals.sops_file_path
}

locals {
  secrets = yamldecode(data.sops_file.secrets.raw)
}

# Reference existing namespace (assumes it exists from helm-chars)
data "kubernetes_namespace" "cert_ingress" {
  metadata {
    name = var.cert_namespace
  }
}

# ClusterIssuer for Let's Encrypt with Cloudflare DNS
resource "kubectl_manifest" "letsencrypt_clusterissuer" {
  yaml_body = yamlencode({
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = var.cluster_issuer_name
    }
    spec = {
      acme = {
        server = var.acme_server
        email  = local.secrets.letsencrypt_email
        privateKeySecretRef = {
          name = var.cluster_issuer_name
        }
        solvers = [
          {
            dns01 = {
              cloudflare = {
                apiTokenSecretRef = {
                  name = var.cloudflare_secret_name
                  key  = "api-token"
                }
              }
            }
          }
        ]
      }
    }
  })

  depends_on = [kubernetes_secret.cloudflare_api_token]
}

# Wildcard certificate for your domain
resource "kubectl_manifest" "wildcard_certificate" {
  yaml_body = yamlencode({
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata = {
      name      = var.certificate_name
      namespace = data.kubernetes_namespace.cert_ingress.metadata[0].name
    }
    spec = {
      secretName = var.certificate_secret_name
      issuerRef = {
        name = var.cluster_issuer_name
        kind = "ClusterIssuer"
      }
      dnsNames    = var.dns_names
      duration    = "2160h" # 90 days
      renewBefore = "360h"  # 15 days before expiry
    }
  })

  depends_on = [kubectl_manifest.letsencrypt_clusterissuer]
}