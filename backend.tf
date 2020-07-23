terraform {
  backend "gcs" {
    bucket = "gcp-bookshelf-bucket"
    prefix = "terraform"
    # project = "gcp-training-iptcp"
  }
}

