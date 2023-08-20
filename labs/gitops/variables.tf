variable "k8s_nodes" {
  description = "master and worker nodes setup that'll be created"
  type = map(object({
    name = string
    startup_script = string
  }))
  default = {
    "k8s-master" = {
      name       = "cks-master"
      startup_script       = "install-master.sh"
    },
    "k8s-worker" = {
      name       = "cks-worker"
      startup_script = "install-worker.sh"
    }
  
  }
}