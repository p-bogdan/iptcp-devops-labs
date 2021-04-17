terraform {
  backend "remote" {
    organization = "devops-labs"

    workspaces {
      name = "iptcp-devops-labs-sentinel"
    }

  }
}