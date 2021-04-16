terraform {
  backend "s3" {
    encrypt = true
    bucket  = "tflab-bluegreen"
    region  = "eu-central-1"
    key     = "v1"
  }
}