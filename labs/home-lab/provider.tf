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
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}


