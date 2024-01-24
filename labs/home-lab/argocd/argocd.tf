resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm" # Official Chart Repo
  chart            = "argo-cd"                              # Official Chart Name
  namespace        = "argocd"
  version          = var.chart_version
  create_namespace = true
set {
  name = "server.service.type"
  value = "NodePort"
}
  values           = [file("${path.module}/argocd.yaml")]
}
