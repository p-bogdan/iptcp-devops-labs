module "compute_network" {
  source              = "git@github.com:ciscoios/iptcp-gcp-reusable-modules.git//modules/gcp/vpc"
  project             = "lab-project-282605"
  region              = "europe-west1"
  network_name        = "k8s-network"
  ipv4_range_backends = "10.132.5.0/24"
  #source_ranges       = ["0.0.0.0/0", "130.211.0.0/22", "35.191.0.0/16", "209.85.152.0/22", "209.85.204.0/22"]
  source_ranges = ["0.0.0.0/0"]
  fw_ports      = ["80", "8080", "443", "22"]
}

module "gke" {
  source                   = "git@github.com:ciscoios/iptcp-gcp-reusable-modules.git//modules/gcp/gke"
  project                  = "lab-project-282605"
  zone                     = "europe-west1-b"
  cluster_name             = "k8s-lab"
  node_count               = "2"
  machine_type             = "n1-standard-1"
  disk_size_gb             = 10
  auto_repair              = true
  auto_upgrade             = true
  cluster_version          = "1.18.12-gke.1210"
  issue_client_certificate = false
  preemptible              = false
  remove_default_node_pool = true
  env                      = "staging"
}
