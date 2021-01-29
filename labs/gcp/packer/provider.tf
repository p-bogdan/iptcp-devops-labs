provider "google" {
  project = var.project
  region  = "europe-west1"
}


terraform {
  required_providers {
    mycloud = {
      source  = "hashicorp/google"
      version = "~> 3.54.0"
    }
  }
}

