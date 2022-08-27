output "region" {
  value = google_compute_subnetwork.gcp-lab-subnet.region
}
output "project" {
  value = google_compute_subnetwork.gcp-lab-subnet.project
}

output "network_name" {
  value = google_compute_network.gcp-lab-network.name
}

output "subnetwork_name" {
  value = google_compute_subnetwork.gcp-lab-subnet.name
}
output "subnetwork_id" {
  value = google_compute_subnetwork.gcp-lab-subnet.id
}

output "subnet_ipv4_range" {
  value = google_compute_subnetwork.gcp-lab-subnet.ip_cidr_range
}

output "subnetwork_self_link" {
  value = google_compute_subnetwork.gcp-lab-subnet.self_link
}

/* output "proxy-subnet-id" {
 value = google_compute_subnetwork.proxy-subnet.id 
} */
/* output "ipv4_range_proxy_subnet" {
value =   google_compute_subnetwork.proxy-subnet.ip_cidr_range
} */
/* 
output "backend_subnet_range" {
  value = google_compute_subnetwork.gcp-lab-subnet.ip_cidr_range
} */

output "network_self_link" {
  value = google_compute_network.gcp-lab-network.self_link
}

/* output "proxy-subnet-http-allow-rule" {
value = google_compute_firewall.proxy-subnet-http-allow-rule.name
} */
