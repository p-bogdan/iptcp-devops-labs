terraform {
  backend "s3" {
    bucket = "lab-state"
    key    = "lab3/tfstate"
    region = "us-east-1"
  }
}
