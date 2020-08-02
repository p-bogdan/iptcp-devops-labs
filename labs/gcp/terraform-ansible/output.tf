#output "project" {
#value = var.project
#}
#output "network_name" {
#value = module.compute_network.network_name    
#}
#output "region" {
#value = var.region
#}

output "instance_template_name" {
  value = module.instance.instance-template_name
}

/* output "instance_network_ip" {
  value = module.instance.instance_network_ip
} */

output "instance_template_group" {
  value = module.instance.instance_group_name
}

/* output "metadata_startup_script" {
  value = module.instance.metadata_startup_script
} */

output "backend_subnet_range" {
  value = module.compute_network.subnet_ipv4_range
}

/* output "proxy_subnet_range" {
  value = module.compute_network.ipv4_range_proxy_subnet
} */

output "sql_instance_name" {
  value = module.sql.google_sql_instance
}

/* output "sql_instance_ip" {
  value = module.sql.private_ip_sql_address
} */

/* output "sql_private_ip_address" {
  value = module.sql.private_ip_address
} */
output "sql_private_ip_address" {
  value = module.sql.private_sql_ip_address
}

output "sql_instance_connection_name" {

  value = module.sql.sql_instance_connection_name
}

output "sql_database_name" {
  value = module.sql.sql_database_name
}


#Looks like nat ip will be only visible in case of manual nat ip assignment
/* output "cloud_nat_ip" {
  value = module.cloud_nat.cloud_nat_ip
} */
output "LB_name" {
  value = module.internal_http_load_balancer.LB_name
}

output "LB_ip_address" {
  value = module.internal_http_load_balancer.LB_ip_address
}

output "cloud_router_nat_name" {
  value = module.cloud_nat.cloud_router_nat_name
}

/* output "cloud_router_nat_address" {
  value = module.cloud_nat.cloud_router_nat_address
} */