terraform {
  backend "remote" {
    organization = "devops-labs"

    workspaces {
      name = "devops-labs-cli-driven"
    }

  }
}