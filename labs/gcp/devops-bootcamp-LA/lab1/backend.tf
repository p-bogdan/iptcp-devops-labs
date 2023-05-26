terraform {
  backend "gcs" {
    bucket = "devops_bootcamp_la"
    prefix = "lab1"
    # project = "gcp-training-iptcp"

  }
}