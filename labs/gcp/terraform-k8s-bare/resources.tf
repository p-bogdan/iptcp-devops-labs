resource "kubernetes_pod" "test" {
  metadata {
    name = "simple-pipeline-app"
  }

  spec {
    container {
      image = "iptcp/simple-app:0.6"
      name  = "example"

      env {
        name  = "environment"
        value = "test"
      }
    command = ["/bin/sh"]
    args = ["-c", "while true; do sh app/build/distributions/app/bin/app; sleep 10;done"]
      port {
        container_port = 8080
      }

      # liveness_probe {
      #   http_get {
      #     path = "/nginx_status"
      #     port = 80

      #     http_header {
      #       name  = "X-Custom-Header"
      #       value = "Awesome"
      #     }
      #   }

      #   initial_delay_seconds = 3
      #   period_seconds        = 3
      # }
    }

    dns_config {
      nameservers = ["1.1.1.1", "8.8.8.8", "9.9.9.9"]
      searches    = ["example.com"]

      option {
        name  = "ndots"
        value = 1
      }

      option {
        name = "use-vc"
      }
    }

    dns_policy = "None"
  }
}
