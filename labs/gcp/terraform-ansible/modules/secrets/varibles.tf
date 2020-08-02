variable "region" {
    default = ""
}

variable "secret_id" {
    default = "tf_ansible_secrets"
}

variable "template_file" {
    default = ""
}

variable "random_id" {
    default = ""
}

variable "secret_data" {
    default = ""
}

/* variable "enabled_secret_versioning" {
    type    = string
    default = 1
} */

variable "local_file" {
    default = ""
}

/* variable "secret_version" {
    default = 1
} */

variable "tf_ansible_vars_file" {
    default = ""
}