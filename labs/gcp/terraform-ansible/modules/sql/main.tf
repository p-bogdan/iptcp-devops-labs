resource "random_id" "instance_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "gcp-lab-sql-instance" {

  name             = "bookshelf-instance-${random_id.instance_name_suffix.hex}"
  region           = var.region
  database_version = "MYSQL_5_7"
  #  depends_on = [google_service_networking_connection.private_vpc_connection]
  #  depends_on  = var.private_vpc_connection
  #   depends_on  = [module.google_service_networking_connection.private_vpc_connection]
  #   depends_on  = [var.private_vpc_connection]
  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier      = "db-n1-standard-1"
    disk_size = "10"


    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_self_link
    }
  }
}

resource "google_sql_database" "gcp-lab-database" {

  name = "bookshelf"
  #name       = "bookshelf-${random_id.db_name_suffix.hex}"
  instance   = google_sql_database_instance.gcp-lab-sql-instance.name
  depends_on = [google_sql_database_instance.gcp-lab-sql-instance]
}

resource "google_sql_user" "default" {
  name = var.user_name
  #  project    = var.project
  instance = google_sql_database_instance.gcp-lab-sql-instance.name
  host     = var.user_host
  password = var.sql_user_password == "" ? random_id.instance_name_suffix.hex : var.sql_user_password
  #  password   = var.sql_user_password
  depends_on = [google_sql_database_instance.gcp-lab-sql-instance]
}

resource "google_compute_global_address" "private_ip_address" {

  name          = "private-ip-block"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  ip_version    = "IPV4"
  prefix_length = 20
  network       = var.network_self_link
}
resource "google_service_networking_connection" "private_vpc_connection" {


  network                 = var.network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

