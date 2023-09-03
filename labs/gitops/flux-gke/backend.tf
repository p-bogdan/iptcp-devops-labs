terraform {
  backend "gcs" {
    bucket = "devops_bootcamp_la"
    prefix = "flux"
    # project = "gcp-training-iptcp"

  }
}