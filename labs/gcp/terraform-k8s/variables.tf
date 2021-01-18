
variable "region" {
  description = "GCP region variable"
  default     = "europe-west1"
}

variable "project" {
  default = "lab-project-282605"
}

variable "zone" {
  description = "Default GCP zone in the project"
  default     = "europe-west1-b"
}

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