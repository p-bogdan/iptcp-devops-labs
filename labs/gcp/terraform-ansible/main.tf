##############################################################################
#Network related modules block

module "compute_network" {
  source = "./modules/vpc"
  #  random_id = module.sql.random_id
  #  target-http-proxy_id = module.internal_http_load_balancer.target-http-proxy_id
}

###############################################################################
#Cloud NAT

module "cloud_nat" {
  source = "./modules/cloud_nat"
  #network_name                    = module.compute_network.network_name
  network_self_link = module.compute_network.network_self_link
  subnetwork_id     = module.compute_network.subnetwork_id
  region            = module.compute_network.region
}
###############################################################################
#SQL

module "sql" {
  source            = "./modules/sql"
  network_self_link = module.compute_network.network_self_link
  #private_vpc_connection          = module.private_ip_for_sql.private_vpc_connection
  region = module.compute_network.region
}
###############################################################################
#Bucket for application data

module "bucket" {
  source = "./modules/bucket"
  #  region           = module.compute_network.region
  #random_id         =  module.sql.random_id 
  random_id_hex = module.sql.random_id_hex
}
###############################################################################



#INSTANCE
module "instance" {
  source              = "./modules/instance"
  region              = module.compute_network.region
  project             = module.compute_network.project
  network_name        = module.compute_network.network_name
  subnetwork_id       = module.compute_network.subnetwork_id
  google_sql_instance = module.sql.google_sql_instance
  google_sql_database = module.sql.google_sql_database
  startup-script      = var.startup-script
  #  tf_ansible_vars_file         = var.tf_ansible_vars_file
  sql_user_password            = module.sql.sql_user_password
  sql_instance_connection_name = module.sql.sql_instance_connection_name
  sql_database_name            = module.sql.sql_database_name
  bookshelf-app-bucket         = module.bucket.bookshelf-app-bucket

}

#SECRETS
module "secrets" {
  source               = "./modules/secrets"
  random_id            = module.sql.random_id
  local_file           = module.instance.local_file
  tf_ansible_vars_file = module.instance.tf_ansible_vars_file
}


#Load balancing

module "internal_http_load_balancer" {
  source                   = "./modules/load_balancer"
  project                  = module.compute_network.project
  region                   = module.compute_network.region
  subnetwork_id            = module.compute_network.subnetwork_id
  instance-template_name   = module.instance.instance-template_name
  instance_group_name      = module.instance.instance_group_name
  instance_group_id        = module.instance.instance_group_id
  instance_group_self_link = module.instance.instance_group_self_link
  instance_group           = module.instance.instance_group
  #  proxy-subnet-id              = module.compute_network.proxy-subnet-id
  #  proxy-subnet-http-allow-rule = module.compute_network.proxy-subnet-http-allow-rule
  network_self_link = module.compute_network.network_self_link
  named_port_name   = module.instance.named_port_name
}


