terraform {
  backend "gcs" {
    bucket = "test-ubuntu-cloud"
    prefix = "terraform"
    # project = "gcp-training-iptcp"

  }
}
