terraform {
  backend "gcs" {
    bucket = "devops_bootcamp_la"
    prefix = "jenkins-sonarqube"
    # project = "gcp-training-iptcp"

  }
}