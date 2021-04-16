locals {
  subnet_count       = 3
  availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  subnets = aws_subnet.terraform-blue-green[*].id

  user_data = <<EOF
    #! /bin/bash
    sudo amazon-linux-extras install -y nginx1
    sudo systemctl start nginx
    sudo systemctl enable nginx
  EOF
}
resource "aws_key_pair" "terraform-blue-green" {
  key_name   = "tf_bluegreen"
  public_key = file("keypairs/tf_bluegreen.pem.pub")
}

resource "aws_subnet" "terraform-blue-green" {
  count                   = local.subnet_count
  vpc_id                  = var.vpc_id
  availability_zone       = element(local.availability_zones, count.index)
  cidr_block              = "10.0.${local.subnet_count * (var.infrastructure_version - 1) + count.index + 1}.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${element(local.availability_zones, count.index)} (v${var.infrastructure_version})"
  }
}
resource "aws_security_group" "terraform-blue-green" {
  description = "Terraform Blue/Green"
  vpc_id      = var.vpc_id
  name        = "terraform-blue-green-v${var.infrastructure_version}"

  tags = {
    Name = "Terraform Blue/Green (v${var.infrastructure_version})"
  }
}
resource "aws_security_group_rule" "terraform-blue-green-inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.terraform-blue-green.id
  from_port         = 0
  to_port           = -1
  protocol          = "all"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "terraform-blue-green-outbound" {
  type              = "egress"
  security_group_id = aws_security_group.terraform-blue-green.id
  from_port         = 0
  to_port           = -1
  protocol          = "all"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_instance" "terraform-blue-green" {
  count                  = 3
  ami                    = "ami-0da5bd92baa5479cc"
  instance_type          = "t2.micro"
  subnet_id              = element(local.subnets, count.index)
  vpc_security_group_ids = [aws_security_group.terraform-blue-green.id]
  key_name               = aws_key_pair.terraform-blue-green.key_name

  user_data = local.user_data

  tags = {
    Name                  = "Terraform Blue/Green ${count.index + 1} (v${var.infrastructure_version})"
    InfrastructureVersion = var.infrastructure_version
  }
}