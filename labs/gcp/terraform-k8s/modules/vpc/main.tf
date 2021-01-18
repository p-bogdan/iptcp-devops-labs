resource "google_compute_network" "gcp-lab-network" {
  project                         = var.project
  name                            = var.network_name
  auto_create_subnetworks         = var.auto_create_subnetworks
  routing_mode                    = var.routing_mode
  delete_default_routes_on_create = var.delete_default_internet_gateway_routes
   
}
resource "google_compute_subnetwork" "gcp-lab-subnet" {
  name          = "gcp-lab-backend-subnet"
  ip_cidr_range = var.ipv4_range_backends
  region        = var.region
  project       = var.project
  network       = google_compute_network.gcp-lab-network.self_link
}

 resource "google_compute_firewall" "gcp-lab-ssh" {
  count         = length(var.source_ranges_backends) > 0 ? 1 : 0
   name         = "${var.network_name}-ingress-ssh"
  description   = "Allow SSH to machines"
  project       = var.project
  network       = google_compute_network.gcp-lab-network.self_link
  source_ranges = var.source_ranges_backends
  direction     = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22"]
    
  }
}

 resource "google_compute_firewall" "internal-routing" {
  name = "${var.network_name}-internal-route"
  network = google_compute_network.gcp-lab-network.self_link
  project       = var.project
  source_ranges = var.source_ranges_backends
  
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
   
  }
  allow {
    protocol = "udp"
  }
  allow {
    protocol = "icmp"
  }
  direction = "INGRESS"
} 


resource "google_compute_firewall" "gcp-tag-http" {
  count         = length(var.source_ranges_backends) > 0 ? 1 : 0
 name          = "${var.network_name}-ingress-tag-http"
  description   = "Allow HTTP to machines with the 'load-balanced-backend' tags"
  network       = google_compute_network.gcp-lab-network.self_link
  project       = var.project
  source_ranges = var.source_ranges_backends
  direction     = "INGRESS"
  allow {
    protocol = "tcp"
   ports    = ["80", "443"]
  }
}