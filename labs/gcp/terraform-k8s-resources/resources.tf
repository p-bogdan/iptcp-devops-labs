resource "kubernetes_namespace" "app" {
  metadata {
    annotations = {
      name = "example-annotation"
    }

    labels = {
      mylabel = "label-value"
    }

    name = "app"
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "scalable-nginx-example"
    namespace = kubernetes_namespace.app.metadata.0.name
    labels = {
      app = "ScalableNginxExample"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "ScalableNginxExample"
      }
    }
    template {
      metadata {
        labels = {
          App = "ScalableNginxExample"
        }
      }
      spec {
        container {
          image = "nginx:1.7.8"
          name  = "example"

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}
# resource "kubernetes_endpoints" "example" {
#   metadata {
#     name = "terraform-example"
#     namespace = "app"
#   }

#   subset {
#     address {
#       ip = "10.0.0.4"
#     }

#     address {
#       ip = "10.0.0.5"
#     }

#     port {
#       name     = "http"
#       port     = 80
#       protocol = "TCP"
#     }

#     port {
#       name     = "https"
#       port     = 443
#       protocol = "TCP"
#     }
#   }
# }

resource "kubernetes_service" "example" {
  metadata {
    name = kubernetes_deployment.nginx.metadata.0.name
    #name = "nginx-example"
    namespace = "app"
    labels = {
      app = "ScalableNginxExample"
    }
  }
  spec {
    selector = {
      app = kubernetes_deployment.nginx.metadata.0.labels.app
    }
    session_affinity = "ClientIP"
    port {
      port     = 8080
      protocol = "TCP"
    }

    type = "LoadBalancer"
  }
}
