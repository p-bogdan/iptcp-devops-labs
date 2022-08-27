##############################################################################
#Network related modules block

module "compute_network" {
  project             = var.project
  region              = var.region
  network_name        = var.network_name
  ipv4_range_backends = var.ipv4_range_backends
  # source = "git::https://github.com/ciscoios/iptcp-gcp-reusable-modules.git//modules/gcp/vpc"
  source = "git@github.com:ciscoios/iptcp-gcp-reusable-modules.git//modules/gcp/vpc"


}
###############################################################################
#Cloud NAT

module "cloud_nat" {
  source            = "git@github.com:ciscoios/iptcp-gcp-reusable-modules.git//modules/gcp/cloud_nat"
  network_self_link = module.compute_network.network_self_link
  subnetwork_id     = module.compute_network.subnetwork_id
  region            = var.region
}
###############################################################################
#SQL

module "sql" {
  source            = "git@github.com:ciscoios/iptcp-gcp-reusable-modules.git//modules/gcp/sql"
  network_self_link = module.compute_network.network_self_link
  region            = var.region
}
###############################################################################
#Bucket for application data

module "bucket" {

  location      = "EU"
  source        = "git@github.com:ciscoios/iptcp-gcp-reusable-modules.git//modules/gcp/bucket"
  random_id_hex = module.sql.random_id_hex
  entity        = "allUsers"
}
###############################################################################



#INSTANCE
module "instance" {
  source                       = "git@github.com:ciscoios/iptcp-gcp-reusable-modules.git//modules/gcp/instance"
  region                       = var.region
  project                      = var.project
  network_name                 = var.network_name
  subnetwork_id                = module.compute_network.subnetwork_id
  google_sql_instance          = module.sql.google_sql_instance
  google_sql_database          = module.sql.google_sql_database
  startup-script               = "startup-script_project.sh"
  sql_user_password            = module.sql.sql_user_password
  sql_instance_connection_name = module.sql.sql_instance_connection_name
  sql_database_name            = module.sql.sql_database_name
  bookshelf-app-bucket         = module.bucket.bookshelf-app-bucket
  email                        = var.email

}

#SECRETS
module "secrets" {
  source               = "git@github.com:ciscoios/iptcp-gcp-reusable-modules.git//modules/gcp/secrets"
  random_id            = module.sql.random_id
  local_file           = module.instance.local_file
  tf_ansible_vars_file = "tf_ansible_vars.yml"
}


#Load balancing

module "internal_http_load_balancer" {
  source                   = "git@github.com:ciscoios/iptcp-gcp-reusable-modules.git//modules/gcp/load_balancer"
  project                  = var.project
  region                   = var.region
  subnetwork_id            = module.compute_network.subnetwork_id
  instance-template_name   = module.instance.instance-template_name
  instance_group_name      = module.instance.instance_group_name
  instance_group_id        = module.instance.instance_group_id
  instance_group_self_link = module.instance.instance_group_self_link
  instance_group           = module.instance.instance_group
  network_self_link        = module.compute_network.network_self_link
  named_port_name          = module.instance.named_port_name
}


