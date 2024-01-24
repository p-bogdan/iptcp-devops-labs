resource "helm_release" "linkerd" {
  #depends_on  = [kubernetes_namespace.security] 
  name       = "linkerd"
  namespace  = "linkerd"

  repository = "https://helm.linkerd.io/stable"
  chart      = "linkerd-crds"

  wait = true
  wait_for_jobs = true
  create_namespace = true
  version = 
  #version = "3.1.5"
}
