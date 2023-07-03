provider "google" {
  project = "ci-cd-387713"
  region  = "us-east1"
}


provider "kubernetes" {
  #load_config_file = false

  host  = "https://${module.gke.k8s-cluster-endpoint}"
  token = module.gke.access_token
  cluster_ca_certificate = base64decode(
    module.gke.cluster_ca_cert,
  )
}

#To get access to Kubernetes cluster inside GCP run this command
#gcloud container clusters get-credentials cluster_name --zone cluster_zone --project project_id

provider "helm" {
  kubernetes {
    host        = "https://${module.gke.k8s-cluster-endpoint}"
    #token       = var.access_token
    token = module.gke.access_token
    config_path = module.gke.kubeconfig
    cluster_ca_certificate = base64decode(
      module.gke.cluster_ca_cert
    )
  }
}



terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      #version = "~> 3.60.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      #version = "~> 2.0.3"
    }
    helm = {
      source  = "hashicorp/helm"
      #version = "~> 2.0.3"
    }
    # template = {
    #   source  = "cloudposse/template"
    #   version = "~> 2.2.0"
    # }
  }
}

