output "google_sql_instance" {
  value = google_sql_database_instance.gcp-lab-sql-instance.id
}

output "google_sql_database" {
  value = google_sql_database.gcp-lab-database.id
}
output "private_vpc_connection" {
  value = google_service_networking_connection.private_vpc_connection.id
}
/* output "private_ip_sql_address" {
value = google_compute_global_address.private_ip_address.address    
}
 */
output "private_sql_ip_address" {
  value = google_sql_database_instance.gcp-lab-sql-instance.ip_address.0.ip_address
}

output "sql_instance_connection_name" {
  value = google_sql_database_instance.gcp-lab-sql-instance.connection_name
}
output "sql_database_name" {
  value = google_sql_database.gcp-lab-database.name
}

output "sql_user_password" {
  value = google_sql_user.default.password
}

output "random_id" {
  value = random_id.instance_name_suffix.id
}
output "random_id_hex" {
  value = random_id.instance_name_suffix.hex
}
