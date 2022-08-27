terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #version = "~> 3.0"
    }
    local = {
      source = "hashicorp/local"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}