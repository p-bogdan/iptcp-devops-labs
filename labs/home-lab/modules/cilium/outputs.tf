output "argocd_version" {
  value = helm_release.cni.metadata.app_version
}

output "helm_revision" {
  value = helm_release.cni.metadata.revision
}

output "chart_version" {
  value = helm_release.cni.metadata.version
}
