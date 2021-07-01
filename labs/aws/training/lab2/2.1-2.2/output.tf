output "bastion_public_ip" {
value = aws_instance.bastion.public_ip
}

output "private_host_ip" {
value = aws_instance.private_subnet.private_ip
}