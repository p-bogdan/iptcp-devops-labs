provider "google" {
  project = "lab-project-282605"
  region  = "europe-west1"
}


provider "kubernetes" {
  load_config_file = var.load_config_file
  project = "lab-project-282605"
  host  = google_container_cluster.primary.endpoint
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.kubernetes_cluster.master_auth.0.cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host = google_container_cluster.kubernetes_cluster.endpoint
    token = data.google_client_config.default.access_token

    cluster_ca_certificate = base64decode(
    google_container_cluster.primary.master_auth.0.cluster_ca_certificate
  )
  }
}

terraform {
  required_providers {
    mycloud = {
      source  = "hashicorp/google"
      version = "~> 3.53.0"
    }
  }
}

