provider "google" {
  project = var.project
  region  = var.region
}


provider "kubernetes" {
  load_config_file = var.load_config_file

  host  = "https://${var.k8s-cluster-endpoint}"
  token = var.provider_access_token
  cluster_ca_certificate = base64decode(
    var.cluster_ca_cert,
  )
}

# provider "helm" {
#   kubernetes {
#     load_config_file       = false
#     cluster_ca_certificate = base64decode(
#     var.cluster_ca_cert,
#   )
#     host                   = "https://${var.k8s-cluster-endpoint}"
#     token                  = var.provider_access_token
#   }
# }

terraform {
  required_providers {
    mycloud = {
      source  = "hashicorp/google"
      version = "~> 3.52.0"
    }
  }
}

