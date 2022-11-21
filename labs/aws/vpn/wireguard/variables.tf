variable "wireguard_template" {
  description = "path to wireguard container config file"
  type = string
  default = "files/docker-compose.tftpl"
}