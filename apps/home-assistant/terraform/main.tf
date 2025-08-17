# apps/home-assistant/terraform/main.tf
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.35.0"
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
resource "kubernetes_namespace" "homeassistant" {
  metadata {
    name = var.namespace
  }
}
