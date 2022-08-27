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
  # network       = google_compute_network.gcp-lab-network.id
  network = google_compute_network.gcp-lab-network.self_link
}

/* resource "google_compute_subnetwork" "proxy-subnet" {
  provider      = google-beta
  name          = "gcp-lab-proxy-subnet"
  ip_cidr_range = var.ipv4_range_proxy_subnet
  region        = var.region
  project       = var.project
  network       = google_compute_network.gcp-lab-network.self_link
  purpose       = "INTERNAL_HTTPS_LOAD_BALANCER"
  role          = "ACTIVE"
} */
resource "google_compute_firewall" "gcp-lab-ssh" {
  count = length(var.source_ranges_backends) > 0 ? 1 : 0
  #  name          = "${var.network_name}-ingress-ssh"
  #  name          = "${var.network_name}-ingress-ssh"
  name        = "${var.network_name}-ingress-ssh"
  description = "Allow SSH to machines"
  project     = var.project
  #network       = var.network_name

  network       = google_compute_network.gcp-lab-network.self_link
  source_ranges = var.source_ranges_backends
  target_tags   = ["allow-ssh"]
  direction     = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]

  }
}

resource "google_compute_firewall" "internal-routing" {
  #  provider = google-beta
  name          = "${var.network_name}-internal-route"
  network       = google_compute_network.gcp-lab-network.self_link
  source_ranges = var.source_ranges_backends
  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "443"]

  }
  # source_tags = ["load-balanced-backend", "allow-health-check"]
  allow {
    protocol = "udp"
  }
  allow {
    protocol = "icmp"
  }
  direction = "INGRESS"
}


resource "google_compute_firewall" "gcp-tag-http" {
  count = length(var.source_ranges_backends) > 0 ? 1 : 0
  name  = "${var.network_name}-ingress-tag-http"
  #name_prefix   = "-ingress-tag-http"
  description = "Allow HTTP to machines with the 'load-balanced-backend' tags"
  #network       = var.network_name
  #network       = google_compute_network.gcp-lab-network.self_link
  network       = google_compute_network.gcp-lab-network.self_link
  project       = var.project
  source_ranges = var.source_ranges_backends
  direction     = "INGRESS"
  target_tags   = ["load-balanced-backend", "allow-health-check"]

  allow {
    protocol = "tcp"
    # ports    = ["80", "8080", "443"]
    ports = ["80", "8080", "443"]
  }
}
/* resource "google_compute_firewall" "proxy-subnet-http-allow-rule" {
#  count         = length(var.ipv4_range_proxy_subnet) > 0 ? 1 : 0
 name          = "${var.network_name}-allow-proxy-subnet-http"
  #name_prefix   = "-ingress-tag-http"
  description   = "Allow HTTP to machines with the 'load-balanced-backend' tags"
  #network       = var.network_name
  #network       = google_compute_network.gcp-lab-network.self_link
  network       = google_compute_network.gcp-lab-network.self_link
  project       = var.project
  source_ranges = [var.ipv4_range_proxy_subnet]
  direction     = "INGRESS"
  target_tags   = ["load-balanced-backend"]

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "443"]
  }
}
 */
resource "google_compute_firewall" "allow-healthcheck-from-google-services" {
  #  count         = length(var.ipv4_range_proxy_subnet) > 0 ? 1 : 0
  name = "${var.network_name}-fw-allow-health-check"
  #name_prefix   = "-ingress-tag-http"

  #For health checks to work, you must create ingress allow firewall rules \
  #so that traffic from Google Cloud probers can connect to your backends.
  description = "Allow healthcheck from google services"
  #network       = var.network_name
  #network       = google_compute_network.gcp-lab-network.self_link
  network       = google_compute_network.gcp-lab-network.self_link
  project       = var.project
  source_ranges = var.healthcheck_subnet_range
  direction     = "INGRESS"
  # target_tags   = ["load-balanced-backend"]
  target_tags = ["allow-health-check", "load-balanced-backend"]

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "443"]
  }
}

resource "google_compute_firewall" "allow-tag-mysql" {
  count = length(var.source_ranges_backends) > 0 ? 1 : 0
  #name          = 
  name        = "${var.network_name}-ingress-tag-mysql"
  description = "Allow access to mysql database 'mysql' tag"
  # network       = var.network_name
  # network       = google_compute_network.gcp-lab-network.self_link
  network       = google_compute_network.gcp-lab-network.self_link
  project       = var.project
  source_ranges = var.source_ranges_backends
  direction     = "INGRESS"
  # target_tags   = ["https-server"]

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }
}
