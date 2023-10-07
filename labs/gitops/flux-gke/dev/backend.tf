terraform {
  backend "gcs" {
    bucket = "devops_bootcamp_la"
    prefix = "flux/dev"
    # project = "gcp-training-iptcp"

  }
}