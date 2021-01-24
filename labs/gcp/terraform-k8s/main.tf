module "compute_network" {
   source = "git@github.com:ciscoios/iptcp-gcp-reusable-modules.git//modules/gcp/vpc"
   project             = "lab-project-282605"
   region              = "europe-west1"
   network_name        = "k8s-network"
   ipv4_range_backends = "10.132.5.0/24"
 }

module "gke" {
  source  = "git@github.com:ciscoios/iptcp-gcp-reusable-modules.git//modules/gcp/gke"
  project = "lab-project-282605"
  zone = "europe-west1-b"
}

