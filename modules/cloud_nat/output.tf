/* output "cloud_nat_ip" {
value = google_compute_router_nat.cloud-router-nat.nat_ips   
} */

output "cloud_router_nat_name" {
value = google_compute_router_nat.cloud-router-nat.name
}
