provider "google" {
  project = "lab-project-282605"
  region  = "europe-west1"
}


provider "kubernetes" {
  load_config_file = var.load_config_file
  project = "lab-project-282605"
  host  = "https://${var.k8s-cluster-endpoint}"
  token = var.provider_access_token
  cluster_ca_certificate = base64decode(
    var.cluster_ca_cert,
  )
}


terraform {
  required_providers {
    mycloud = {
      source  = "hashicorp/google"
      version = "~> 3.53.0"
    }
  }
}

