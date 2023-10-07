terraform {
  backend "gcs" {
    bucket = "devops_bootcamp_la"
    prefix = "flux/staging"
    # project = "gcp-training-iptcp"

  }
}