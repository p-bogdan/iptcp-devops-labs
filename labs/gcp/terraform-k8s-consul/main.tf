module "compute_network" {
   source = "git@github.com:ciscoios/iptcp-gcp-reusable-modules.git//modules/gcp/vpc"
   project             = "lab-project-282605"
   region              = "us-east1"
   network_name        = "k8s-network"
   ipv4_range_backends = "10.132.5.0/24"
   source_ranges       = ["0.0.0.0/0"] 
   fw_ports            = ["80", "8080", "443", "22"]
 }

module "gke" {
  source  = "git@github.com:ciscoios/iptcp-gcp-reusable-modules.git//modules/gcp/gke"
  project = "lab-project-282605"
  zone = "us-east1-b"
  cluster_name = "k8s-lab"
  node_count = "3"
  machine_type = "n1-standard-1"
  disk_size_gb = 10
  auto_repair = true
  auto_upgrade = true
  cluster_version = "1.21.5-gke.1302"
  issue_client_certificate = false
  preemptible = false
  remove_default_node_pool = true
  env = "staging"
}

resource "helm_release" "consul" {
  depends_on = [module.gke, module.compute_network]
  name       = "consul"
  namespace  = "consul"

  repository = "https://helm.releases.hashicorp.com"
  chart      = "consul"

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}

resource "kubernetes_namespace" "consul" {
  depends_on = [module.gke, module.compute_network]
  metadata {
    annotations = {
      name = "consul"
    }

    labels = {
      mylabel = "consul"
    }

    name = "consul"
  }
}