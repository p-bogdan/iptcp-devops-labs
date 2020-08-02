/* variable "region" {
} */

 variable "private_vpc_connection" {
 default = ""
} 

variable "network_self_link" {
default = ""
}

variable "region" {
default = ""
}
variable "user_name" {
  description = "The name of the default user"
  type        = string
  default     = "root"
}
variable "user_host" {
  description = "The host for the default user"
  type        = string
  default     = "%"
}

 variable "sql_user_password" {
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
  type        = string
  default     = ""
} 