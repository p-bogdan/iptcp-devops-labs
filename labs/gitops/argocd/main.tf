module "compute_network" {
  source              = "git@github.com:p-bogdan/iptcp-gcp-reusable-modules.git//modules/gcp/vpc"
  project             = "ci-cd-387713"
  region              = "us-east1"
  network_name        = "k8s-network"
  ipv4_range_backends = "10.0.0.0/16"
  source_ranges       = ["0.0.0.0/0"]
  #fw_ports            = ["80", "8080", "443", "22", "1024-65535"]
  fw_ports            = ["80", "8080", "443", "22", "1024-65535"]
}

module "gke" {
  depends_on               = [module.compute_network]
  source                   = "git@github.com:p-bogdan/iptcp-gcp-reusable-modules.git//modules/gcp/gke"
  project                  = "ci-cd-387713"
  zone                     = "us-east1-b"
  cluster_name             = "k8s-lab"
  network                  = "k8s-network"
  subnetwork               = "gcp-lab-backend-subnet"
  node_count               = "2"
  machine_type             = "n1-standard-1"
  disk_size_gb             = 20
  auto_repair              = true
  auto_upgrade             = true
  cluster_version          = "1.27.2-gke.1200"
  issue_client_certificate = false
  preemptible              = false
  remove_default_node_pool = true
  env                      = "staging"
}

resource "helm_release" "argocd" {
  depends_on = [module.gke, module.compute_network]
  name       = "argocd"
  namespace  = "argocd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  wait = true
  wait_for_jobs = true
  create_namespace = true
  set {
    name  = "server.service.type"
    value = "NodePort"
  }
}
