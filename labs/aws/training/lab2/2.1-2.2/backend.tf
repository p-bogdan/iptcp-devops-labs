terraform {
  backend "s3" {
    bucket = "lab-state"
    key    = "lab_2.1/tfstate"
    region = "us-east-1"
  }
}
