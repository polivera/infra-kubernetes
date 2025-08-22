# apps/valkey/terraform/main.tf
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

module "globals" {
  source = "../../../modules/globals"
}

provider "kubernetes" {
  config_path = module.globals.config_path
}

# apps/valkey/terraform/namespace.tf
resource "kubernetes_namespace" "valkey" {
  metadata {
    name = var.namespace
  }
}


