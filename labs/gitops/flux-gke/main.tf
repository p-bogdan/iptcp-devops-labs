module "compute_network" {
  source              = "git@github.com:p-bogdan/iptcp-gcp-reusable-modules.git//modules/gcp/vpc"
  project             = "ci-cd-387713"
  region              = "us-east1"
  network_name        = "k8s-network"
  ipv4_range_backends = "10.132.5.0/24"
  source_ranges       = ["0.0.0.0/0"]
  fw_ports            = ["80", "8080", "443", "22", "30000-32767"]
  target_tags         = ["k8s"]
}

module "gke" {
  depends_on               = [module.compute_network]
  source                   = "git@github.com:p-bogdan/iptcp-gcp-reusable-modules.git//modules/gcp/gke"
  project                  = "ci-cd-387713"
  zone                     = "us-east1-b"
  cluster_name             = "k8s-lab"
  node_count               = "2"
  machine_type             = "n1-standard-1"
  disk_size_gb             = 20
  auto_repair              = true
  auto_upgrade             = true
  cluster_version          = "1.27.4-gke.900"
  issue_client_certificate = false
  preemptible              = false
  remove_default_node_pool = true
  env                      = "staging"
  network              = "k8s-network"
  subnetwork           = module.compute_network.subnetwork_id
  gke_tags             = ["k8s"]
}

resource "tls_private_key" "flux" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "github_repository_deploy_key" "this" {
  title      = "Flux"
  repository = var.github_repository
  key        = tls_private_key.flux.public_key_openssh
  read_only  = "false"
}

# resource "kubernetes_namespace" "flux_system" {
#   metadata {
#     name = "flux-system"
#   }

#   lifecycle {
#     ignore_changes = [
#       metadata[0].labels,
#     ]
#   }
# }

resource "flux_bootstrap_git" "this" {
  #depends_on = [module.gke, module.compute_network ]
  depends_on = [github_repository_deploy_key.this]
  #components = [source-controller kustomize-controller helm-controller notification-controller]
  components = ["source-controller", "kustomize-controller"]
  #namespace = kubernetes_namespace.flux_system.metadata.0.name
  #namespace = "flux-system"
  path = "clusters/dev"

  # provisioner "local-exec" {
  #   when       = destroy
  #   command    = "kubectl patch customresourcedefinition helmcharts.source.toolkit.fluxcd.io helmreleases.helm.toolkit.fluxcd.io helmrepositories.source.toolkit.fluxcd.io kustomizations.kustomize.toolkit.fluxcd.io gitrepositories.source.toolkit.fluxcd.io -p '{\"metadata\":{\"finalizers\":null}}'"
  #   on_failure = continue
  # }
  #   provisioner "local-exec" {
  #   when    = destroy
  #   #interpreter = ["bash", "-c"]
  #   command = "flux uninstall -n flux-system --silent"
  # }
  #flux uninstall (yes)
}
