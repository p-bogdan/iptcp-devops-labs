
provider "google" {
  version = "~> 3.23"
  # project = "gcp-training-iptcp"
  project = "gcp-training-iptcp"
  region  = "var.region"
}

provider "google-beta" {
  region = var.region
  #  zone   = var.region-b
}