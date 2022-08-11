terraform {
  backend "s3" {
    bucket = "wireguard-lab"
    key    = "dev"
    region = "us-east-1"
  }
}