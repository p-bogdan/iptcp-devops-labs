terraform {
  backend "s3" {
    bucket = "wireguard-iptcp"
    key    = "dev"
    region = "us-east-1"
  }
}