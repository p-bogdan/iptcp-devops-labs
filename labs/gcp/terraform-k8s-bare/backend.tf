terraform {
  backend "gcs" {
    bucket = "gcp-terraform-k8s"
    prefix = "terraform"
    # project = "gcp-training-iptcp"

  }
}