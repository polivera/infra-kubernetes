terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.35.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17"
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
  kubernetes {
    config_path = module.globals.config_path
  }
}