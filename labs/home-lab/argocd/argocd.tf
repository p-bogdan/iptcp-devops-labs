
# resource "kubernetes_namespace" "argocd" {
#   metadata {
#     annotations = {
#       "meta.helm.sh/release-name" = "argocd",
#       "meta.helm.sh/release-namespace" = "argocd"
#     }

#     labels = {
#       "app.kubernetes.io/managed-by" = "Helm"
#     }

#     name = "argocd"
#   }
# }


resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm" # Official Chart Repo
  chart            = "argo-cd"                              # Official Chart Name
  namespace        = "argocd"
  version          = var.chart_version
  create_namespace = true
  timeout = 600
  lint = true
  recreate_pods = true
  wait = true
  wait_for_jobs = true

set {
  name = "server.service.type"
  value = "NodePort"
}
  values           = [file("${path.module}/argocd.yaml")]
}
