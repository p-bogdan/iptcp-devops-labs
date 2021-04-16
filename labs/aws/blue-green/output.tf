output "instance_public_ips" {
  value = aws_instance.terraform-blue-green.*.public_ip
}