terraform {
  backend "gcs" {
    bucket = "cks-iptcp"
    prefix = "lab1"
    # project = "gcp-training-iptcp"

  }
}