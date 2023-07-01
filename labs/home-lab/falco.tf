resource "helm_release" "falco" {
  #depends_on  = [kubernetes_namespace.security] 
  name       = "falcosecurity"
  namespace  = "falco"

  repository = "https://falcosecurity.github.io/charts"
  chart      = "falco"

  # set {
  #   name = "tty"
  #   value = "true"
  # }
set {
  name = "ebpf.enabled"
  value = true
}
  wait = true
  wait_for_jobs = true
  create_namespace = true
  #version = "3.2.1" (appversion = 0.35.0)
  #version = "3.1.5" (appversion = 0.34.1)
  version = "3.1.5"
}