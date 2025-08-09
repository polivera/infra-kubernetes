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
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.2"
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

provider "helm" {
  kubernetes = {
    config_path = module.globals.config_path
  }
}

provider "kubectl" {
  config_path = module.globals.config_path
}

# SOPS data source for secrets
data "sops_file" "secrets" {
  source_file = module.globals.sops_file_path
}

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = var.namespace
  }
}

# Namespace for the certificate and ingress
resource "kubernetes_namespace" "cert_ingress" {
  metadata {
    name = module.globals.ingress_namespace
  }
}

locals {
  secrets = yamldecode(data.sops_file.secrets.raw)
}
