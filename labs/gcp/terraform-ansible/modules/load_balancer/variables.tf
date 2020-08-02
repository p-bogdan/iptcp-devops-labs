#Env variables
####################
variable "project" {
default = ""    
}

variable "region" {
default = ""    
}
######################

#Instance variables
##############################
variable "instance_group_id" {
default = ""    
}
variable "instance-template_name" {
default = ""
}
variable "instance_group" {
default = ""    
}

variable "named_port_name" {
default = ""    
}

variable "http_check_port_name" {
  default = "http-check-port-name"
}


variable "instance_group_name" {
default = ""    
}
 variable "instance_group_self_link" {
default = ""    
}

variable "proxy-subnet-id" {
default = ""  
}
variable "proxy-subnet-http-allow-rule" {
default = ""    
}

variable "network_self_link" {
default = ""  
}

variable "subnetwork_id" {
default = ""  
}


variable "lb_name" {
  default = "bookshelf-http"  
}
 variable "http_forward" {
  description = "Set to `false` to disable HTTP port 8080 forward"
  type        = bool
  default     = true
} 

variable "create_url_map" {
  description = "Set to `false` if url_map variable is provided."
  type        = bool
  default     = true
}

#######################################
#############

#Backend variables from output
#################################################
/* variable "healthcheck_self_link" {
default = ""    
} */

#Url map
/* 
variable "backend_service_id" {
default = ""    
} */

/* #target http proxy
variable "url-map-id" {
default = ""    

} */

#http healthcheck


