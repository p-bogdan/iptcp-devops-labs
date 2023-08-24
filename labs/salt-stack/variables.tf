variable "k8s_nodes" {
  description = "master and minion node setup that'll be created"
  type = map(object({
    name = string
    startup_script = string
  }))
  default = {
    "salt-master" = {
      name       = "salt-master"
      startup_script       = "install-salt-master.sh"
    },
    "salt-minion" = {
      name       = "salt-minion"
      startup_script = "install-salt-minion.sh"
    }
  
  }
}