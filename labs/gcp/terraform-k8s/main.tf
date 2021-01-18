module "compute_network" {
  source  = "./modules/vpc"
  project = var.project
  region  = var.region
}

# module "compute_network" {
#   source = "git@github.com:ciscoios/iptcp-gcp-reusable-modules.git//modules/gcp/k8s"
#   project = var.project
#   region  = var.region
#  random_id = module.sql.random_id
#  target-http-proxy_id = module.internal_http_load_balancer.target-http-proxy_id
# }

module "gke" {
  source  = "git@github.com:ciscoios/iptcp-gcp-reusable-modules.git//modules/gcp/gke"
  project = var.project
  #  region = var.region
  zone = var.zone
}
#module "helm" {
#  source = "./modules/helm" 
#}
#  zone    = var.zone
#  cluster_version = "1.17.14-gke.1600"
#}

