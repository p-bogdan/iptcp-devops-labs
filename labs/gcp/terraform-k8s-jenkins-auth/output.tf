output "cluster_ip" {
    value = module.gke.k8s-cluster-endpoint
}