resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = var.chart_version
  create_namespace = true
  timeout          = 600
  lint             = true
  recreate_pods    = true
  wait             = true
  wait_for_jobs    = true

  set = [
    {
      name  = "server.service.type"
      value = "NodePort"
    }
  ]

  values = [file("${path.module}/argocd.yaml")]
}
