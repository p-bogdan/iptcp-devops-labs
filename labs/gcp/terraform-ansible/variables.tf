#variable "project_id" {
#description = "my project id"
#default = "gcp-training-iptcp"
#}

variable "region" {
  description = "GCP region variable"
  default     = "europe-west1"
}

variable "project" {
  default = "lab-project"
}

/*     variable "metadata_startup_script" {
  default = ""
}  */

variable "startup-script" {
  description = "User startup script to run when instances spin up"
  #  default     = "startup-script_project.sh"
  #  default = "startup-script_project.sh"
  # type    = string
  #  default = "" 
}
/*    variable "tf_ansible_vars_file" {
  description = "Generating ansible variables in ansible/file_name"
  #  default = ""
}   */

#variable "network_name" {
#default = module.compute_network.network_name
#}