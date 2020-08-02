#variable "project_id" {
#description = "my project id"
#default = "gcp-training-iptcp"
#}

variable "region" {
  description = "GCP region variable"
  default     = "europe-west1"
}

variable "project" {
  default = "lab-project-282605"
}

/*     variable "metadata_startup_script" {
  default = ""
}  */

variable "network_name" {
  default = "gcp-lab-network"
}

variable "ipv4_range_backends" {
  default = "10.132.1.0/24"
}

 variable "entity" {
# #  default = "terraform-sa@lab-project-282605.iam.gserviceaccount.com"
 default = "allUsers"
 }

 variable "email" {
   default = "terraform-sa@lab-project-282605.iam.gserviceaccount.com"
 }

#variable "role_entity" {
#  default = "OWNER:terraform-sa@lab-project-282605.iam.gserviceaccount.com"
#}

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