module "compute_network" {
  source              = "git@github.com:p-bogdan/iptcp-gcp-reusable-modules.git//modules/gcp/vpc"
  project             = "ci-cd-387713"
  region              = "us-east1"
  network_name        = "k8s-network"
  ipv4_range_backends = "10.132.5.0/24"
  source_ranges       = ["0.0.0.0/0"]
  fw_ports            = ["80", "8080", "443", "22"]
}

module "gke" {
  source                   = "git@github.com:p-bogdan/iptcp-gcp-reusable-modules.git//modules/gcp/gke"
  project                  = "ci-cd-387713"
  zone                     = "us-east1-b"
  cluster_name             = "k8s-lab"
  node_count               = "2"
  machine_type             = "n1-standard-1"
  disk_size_gb             = 20
  auto_repair              = true
  auto_upgrade             = true
  cluster_version          = "1.27.3-gke.1700"
  issue_client_certificate = false
  preemptible              = false
  remove_default_node_pool = true
  env                      = "staging"
}

resource "helm_release" "jenkins" {
  depends_on = [module.gke, module.compute_network]
  name       = "jenkins"
  namespace  = "jenkins"

  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  wait = true
  wait_for_jobs = true
  create_namespace = true
  #set {
  set_list {
    #works for dictionary part of config
    # controller:
    #   additionalplugins:
    #     - sonar:2.15
    #name  = "controller.additionalPlugins[0]"
    name = "controller.additionalPlugins"
    #value = "sonar:2.15"
    value = ["sonar:2.15", "jacoco:3.3.4", "maven-plugin:3.22"]
  }
  set {
    name = "agent.resources.limits.cpu"
    value = "2000m"
  }
  set {
    name = "agent.resources.limits.memory"
    value = "6144Mi"
  }
  set {
    name = "agent.resources.requests.cpu"
    value = "1500m"
  }
  set {
    name = "agent.resources.requests.memory"
    value = "4608Mi"
  }
}