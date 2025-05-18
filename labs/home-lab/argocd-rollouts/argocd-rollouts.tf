
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


resource "helm_release" "argocd-rollouts" {
  name             = "argocd-rollouts"
  repository       = "https://argoproj.github.io/argo-helm" # Official Chart Repo
  chart            = "argo-rollouts"                              # Official Chart Name
  namespace        = "argocd"
  version          = var.chart_version
  create_namespace = true
  timeout = 600
  lint = true
  recreate_pods = true
  wait = true
  wait_for_jobs = true

set {
  name = "dashboard.service.type"
  value = "NodePort"
}

set {
  name = "dashboard.service.nodePort"
  value = "31000"
}
set {
  name = "dashboard.enabled"
  value = "true"
}
  #values           = [file("${path.module}/argocd.yaml")]
}
