# apps/mysql/terraform/main.tf
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
  source = "../../../../../modules/globals"
}

provider "kubernetes" {
  config_path = module.globals.config_path
}

data "sops_file" "secrets" {
  source_file = "../${module.globals.sops_file_path}"
}

# Reference existing namespace - DON'T CREATE IT
data "kubernetes_namespace" "mysql" {
  metadata {
    name = var.namespace
  }
}
