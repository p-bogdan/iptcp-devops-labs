
variable "project" {
  default = "gcp-training-iptcp"
}
variable "region" {
  default = "europe-west1"
}

variable "network_name" {
  description = "custom network name for gcp lab"
  default     = "gcp-lab-network"
}

variable "auto_create_subnetworks" {
  type        = bool
  description = "When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources."
  default     = false
}
variable "routing_mode" {
  type = string
  #  default     = "REGIONAL"
  default     = ""
  description = "The network routing mode (default 'GLOBAL')"
}
variable "delete_default_internet_gateway_routes" {
  type        = bool
  description = "If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted"
  default     = false
}
variable "ipv4_range_backends" {
  #default = "10.132.0.0/20"
  default = "10.132.1.0/24"
}
/* variable "ipv4_range_proxy_subnet" {
#default = "10.132.0.0/20"
default = "10.132.2.0/24"
} */

/* variable "ipv4_range_proxy_subnet" {
description = "Fill up output proxy subnet range value"
default     = ""    
} */
variable "source_ranges_backends" {
  type        = list(string)
  description = "List of CIDR block ranges"
  #default     = ["0.0.0.0/0"]
  default = ["0.0.0.0/0"]
}

variable "healthcheck_subnet_range" {
  type        = list(string)
  description = "List of CIDR block ranges"
  #default     = ["0.0.0.0/0"]
  default = ["130.211.0.0/22", "35.191.0.0/16", "209.85.152.0/22", "209.85.204.0/22"]
}


/* variable "network_self_link" {
default = ""    
} */

variable "target-http-proxy_id" {
  default = ""
}

/* variable "proxy-subnet-id" {
default = ""    
} */
