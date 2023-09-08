output "ips" {
value = google_compute_instance.default["salt-master"].network_interface.0.network_ip
}