resource "kubernetes_service_account" "example" {
  metadata {
    name = "jenkins"
  }
}
resource "kubernetes_secret" "example" {
  metadata {
    name = "jenkins"  
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.example.metadata.0.name
    }
  }

  type = "kubernetes.io/service-account-token"
}


resource "kubernetes_role" "example" {
  metadata {
    name = "jenkins"
    labels = {
      service = "jenkins"
    }
  }

  rule {
    api_groups     = [""]
    resources      = ["pods"]
    verbs          = ["create","delete","get","list","patch","update","watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/exec"]
    verbs      = ["create","delete","get","list","patch","update","watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/log"]
    verbs      = ["get","list","watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get"]
  }
}

resource "kubernetes_role_binding" "example" {
  metadata {
    name      = "jenkins"
    namespace = "default"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "jenkins"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "jenkins"
    namespace = "default"
  }
}