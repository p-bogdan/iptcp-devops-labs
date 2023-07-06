terraform {
  backend "gcs" {
    bucket = "devops_bootcamp_la"
    prefix = "argocd"
    # project = "gcp-training-iptcp"

  }
}