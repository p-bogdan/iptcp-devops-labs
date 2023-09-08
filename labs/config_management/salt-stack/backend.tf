terraform {
  backend "gcs" {
    bucket = "devops_labs"
    prefix = "salt-stack"
    # project = "gcp-training-iptcp"

  }
}