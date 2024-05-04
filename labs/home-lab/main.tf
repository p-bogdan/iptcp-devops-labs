module "argocd" {
source = "./argocd"
chart_version = "6.7.18"
}

# Can be deployed ONLY after ArgoCD deployment: depends_on = [module.argocd_dev_root]
module "argocd_dev_root" {
  source             = "./argocd/terraform_argocd_dev_root"
  git_source_path    = "lab-dev/applications"
  git_source_repoURL = "git@github.com:p-bogdan/argocd-charts.git"
}

