
#Kubernetes section
variable "load_config_file" {
  type    = bool
  default = false
}

variable "k8s-cluster-endpoint" {
  default = ""
}

variable "cluster_ca_cert" {
  default = ""
}

variable "provider_access_token" {
  default = "europe-west1-b"

}
