resource "digitalocean_droplet" "cks" {
  image  = "ubuntu-20-04-x64"
  name   = "cks"
  region = "ams3"
  size   = "s-1vcpu-2gb"
  #ssh keys from remote home access
  ssh_keys = [38416289]
}