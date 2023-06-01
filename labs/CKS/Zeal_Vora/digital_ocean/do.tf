resource "digitalocean_droplet" "cks" {
  #Ubuntu 20 - image  = "ubuntu-20-04-x64"
  #Ubuntu 22
  image  =  "ubuntu-22-04-x64"
  name   = "cks"
  region = "ams3"
  # 1vcpu, 2gb
  #size   = "s-1vcpu-2gb"
  size = "s-2vcpu-2gb"
  #ssh keys from remote home access
  ssh_keys = [38416289]
}