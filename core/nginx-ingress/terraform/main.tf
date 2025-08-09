terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
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

# Create namespace for ingress controller
resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = var.namespace
  }
}
