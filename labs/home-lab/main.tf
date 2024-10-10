# data "http" "manifestfile" {
#   url = "https://raw.githubusercontent.com/argoproj/argo-cd/e612199c68e392f1fe8b65fcd5937988b53dbb1d/manifests/crds/applicationset-crd.yaml"
# }

# data "kubectl_file_documents" "docs" {
#     content = data.http.manifestfile.response_body
# }


# resource "kubernetes_namespace" "appset" {
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

# resource "kubectl_manifest" "argocd-pre-install" {
#     #depends_on = [kubectl_manifest.argocd]
#     for_each  = data.kubectl_file_documents.docs.manifests
#     yaml_body = each.value
#     override_namespace = kubernetes_namespace.appset.metadata[0].name
#     ignore_fields = ["metadata.annotations", "metadata.labels"]
#     force_new = true
#     force_conflicts = true
# }

module "cni" {
  source = "./modules/cilium"
  chart_version = "1.16.2"
}

module "argocd" {
depends_on = [module.cni]
source = "./argocd"
chart_version = "7.6.8"
}

# Can be deployed ONLY after ArgoCD deployment: depends_on = [module.argocd_dev_root]
# module "argocd_appset" {
#   source             = "./argocd/argocd_appset"
#   depends_on         = [kubectl_manifest.argocd-pre-install, module.argocd]
#   git_source_path    = "lab-dev/applications"
#   git_source_repoURL = "git@github.com:p-bogdan/argocd-charts.git"
# }

