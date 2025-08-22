# apps/searxng/terraform/main.tf
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.35.0"
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

# Create namespace
resource "kubernetes_namespace" "searxng" {
  metadata {
    name = var.namespace
  }
}

data "sops_file" "secrets" {
  source_file = module.globals.sops_file_path
}

locals {
  secrets = yamldecode(data.sops_file.secrets.raw)
  app_url = "search.${module.globals.domain}"
}