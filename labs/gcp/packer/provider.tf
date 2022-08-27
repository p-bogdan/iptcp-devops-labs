provider "google" {
  project = "lab-project-282605"
  region  = "europe-west1"
}

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      #version = "~> 3.64.0"
    }
  }
}
