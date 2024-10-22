data "kubectl_file_documents" "bgp_manifests" {
    content = file("${path.module}/templates/cilium-bgp-cluster-config.yaml")
}



resource "kubectl_manifest" "cilium_bgp_cluster_config" {
  depends_on       = [helm_release.cni]
  #count     = length(data.kubectl_path_documents.bgp_manifests)
  for_each  = data.kubectl_file_documents.bgp_manifests.manifests
  #yaml_body = element(data.kubectl_path_documents.bgp_manifests.documents, count.index)
  yaml_body = each.value
  server_side_apply = true
}

resource "helm_release" "cni" {
  name             = "cilium"
  #depends_on       = [kubernetes_config_map.bgp-config]
  repository       = "https://helm.cilium.io" # Official Chart Repo
  chart            = "cilium"                              # Official Chart Name
  namespace        = "kube-system"
  version          = var.chart_version
  create_namespace = true
  timeout = 600
  lint = true
  wait = true
  wait_for_jobs = true
# set {
#   name = "server.service.type"
#   value = "NodePort"
# }
  values           = [file("${path.module}/cilium.yaml")]
}
