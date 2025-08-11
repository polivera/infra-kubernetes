# monitoring/terraform/main.tf
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

data "sops_file" "secrets" {
  source_file = module.globals.sops_file_path
}

# Create monitoring namespace
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
  }
}

