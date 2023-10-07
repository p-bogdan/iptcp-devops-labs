variable "github_token" {
  sensitive = true
  type      = string
}

variable "github_org" {
  type = string
  default = "p-bogdan"
}

variable "github_repository" {
  type = string
  default = "flux-infra"
}

# variable "branch" {
#   type = list(string)
#   default = ["dev", "staging"]
# }