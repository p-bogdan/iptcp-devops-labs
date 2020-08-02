resource "google_compute_router" "cloud_nat_router" {
  name    = "cloud-router"
  region  = var.region
 # network = google_compute_network.net.id
  network       = var.network_self_link
}
  #bgp {
  #  asn = 64514
  #}


resource "google_compute_router_nat" "cloud-router-nat" {
  name                               = "cloud-router-nat"
  router                             = google_compute_router.cloud_nat_router.name
  region                             = google_compute_router.cloud_nat_router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = var.subnetwork_id
    source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE"]
  }
 
}
