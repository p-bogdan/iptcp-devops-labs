provider "kubernetes" {
config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      #version = "~> 2.6.1"
    }
    helm = {
      source  = "hashicorp/helm"
      #version = "~> 2.4.1"
    }
  }
}