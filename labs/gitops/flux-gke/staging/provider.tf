provider "google" {
  project = "ci-cd-387713"
  region  = "us-east1"
}

# provider "flux" {
#   kubernetes = {
#     config_path = "~/.kube/config"
#   }
#   # git = {
#   #   url  = "https://github.com/p-bogdan/flux-infra.git"
#   #   #ssh = {
#   #   #  username    = "git"
#   #   #  private_key = "~/.ssh/google_compute_engine"
#   #   #}
#   # }
# }

provider "flux" {
  kubernetes = {
    #config_context = "staging"
    host                   = "https://${module.gke_staging.k8s-cluster-endpoint}"
    #client_certificate     = module.gke_staging.client_certificate
    #client_key             = module.gke_staging.client_key
    #token = module.gke_staging.access_token
    token = module.gke_staging.access_token
    config_path = module.gke_staging.kubeconfig
    cluster_ca_certificate = base64decode(
    module.gke_staging.cluster_ca_cert,
  )
  }
    git = {
      url = "ssh://git@github.com/${var.github_org}/${var.github_repository}.git"
      branch = "staging"
      ssh = {
        username    = "git"
        private_key = tls_private_key.flux.private_key_pem
      }
    }
}


provider "github" {
  owner = var.github_org
  token = var.github_token
}

provider "kubernetes" {
  #load_config_file = false
  #config_context = "staging"
  host  = "https://${module.gke_staging.k8s-cluster-endpoint}"
  token = module.gke_staging.access_token
  cluster_ca_certificate = base64decode(
    module.gke_staging.cluster_ca_cert,
  )
}

#To get access to Kubernetes cluster inside GCP run this command
#gcloud container clusters get-credentials cluster_name --zone cluster_zone --project project_id

provider "helm" {
  kubernetes {
    #config_context = "staging"
    host        = "https://${module.gke_staging.k8s-cluster-endpoint}"
    #token       = var.access_token
    token = module.gke_staging.access_token
    config_path = module.gke_staging.kubeconfig
    cluster_ca_certificate = base64decode(
      module.gke_staging.cluster_ca_cert
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
     flux = {
      source  = "fluxcd/flux"
      #version = ">= 1.0.0"
    }
      github = {
      source  = "integrations/github"
      #version = ">=5.18.0"
    }
  }
}

