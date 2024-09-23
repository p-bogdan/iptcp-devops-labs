output "argocd_version" {
  value = helm_release.cni.metadata[0].app_version
}

output "helm_revision" {
  value = helm_release.cni.metadata[0].revision
}

output "chart_version" {
  value = helm_release.cni.metadata[0].version
}