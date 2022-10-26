locals {
  public_subnets = {
    az_a = {
      name              = "my-dev-01-sub-pub-a"
      cidr_block        = "172.16.1.0/24"
      availability_zone = "us-east-1a"
    },
  }
  private_subnets = {
    az_a = {
      name              = "my-dev-01-sub-priv-a"
      cidr_block        = "172.16.2.0/24"
      availability_zone = "us-east-1a"
    },
  }
  # nat_gateways = {
  #   public_gw1 = {
  #     name = "my-dev-01-natgw-a"
  #     #subnet  = "${aws_subnet.public_subnets["az_a"]}"
  #     subnet        = "${aws_subnet.public_subnets["az_a"].id}"
  #     allocation_id = "${aws_eip.default[0].id}"
  #   },
  # }

  # routes_private = {
  #   rt1_priv = {
  #     cidr_block     = "0.0.0.0/0"
  #     nat_gateway_id = "${aws_nat_gateway.public_subnets["public_gw1"].id}"
  #     name           = "my-dev-01-sub-priv-a"
  #   },
  # }
}

resource "aws_vpc" "my-vpc-01" {
  cidr_block       = "172.16.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name  = "my-vpc-01"
    stack = "dev-01"
    owner = "Petro Bogdan"
  }
}

resource "aws_subnet" "public_subnets" {
  for_each                = local.public_subnets
  vpc_id                  = aws_vpc.my-vpc-01.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "${each.value.name}"
  }
}

# resource "aws_subnet" "private_subnets" {
#   for_each          = local.private_subnets
#   vpc_id            = aws_vpc.my-vpc-01.id
#   cidr_block        = each.value.cidr_block
#   availability_zone = each.value.availability_zone
#   tags = {
#     Name = "${each.value.name}"
#   }
# }

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my-vpc-01.id
  tags = {
    Name = "my-vpc-01-igw"
  }
}


resource "aws_route_table" "int_gw" {
  vpc_id = aws_vpc.my-vpc-01.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# resource "aws_route_table" "private" {
#   vpc_id   = aws_vpc.my-vpc-01.id
#   for_each = local.routes_private
#   route {
#     cidr_block = each.value.cidr_block
#     gateway_id = each.value.nat_gateway_id
#   }
#   tags = {
#     Name = "${each.value.name}"
#   }

# }

resource "aws_eip" "default" {
  count      = 1
  depends_on = [aws_internet_gateway.gw]
}

# resource "aws_nat_gateway" "public_subnets" {
#   for_each      = local.nat_gateways
#   subnet_id     = each.value.subnet
#   allocation_id = each.value.allocation_id
#   //connectivity_type default public
#   tags = {
#     Name = "${each.value.name}"
#   }

#   # To ensure proper ordering, it is recommended to add an explicit dependency
#   # on the Internet Gateway for the VPC.
#   depends_on = [aws_internet_gateway.gw]
# }

resource "aws_route_table_association" "public_subnets" {
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.int_gw.id
}

resource "aws_main_route_table_association" "public" {
  vpc_id         = aws_vpc.my-vpc-01.id
  route_table_id = aws_route_table.int_gw.id
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]


  filter {
    name   = "name"
    #values = ["amzn2-ami-hvm*"] #kernel 4.14
    #values = ["amzn2-ami-kernel*"] #kernel 5.10
    values = ["al2022*"] #amazon linux 2022
  }
}

variable "AWS_SSH_KEY" {}
variable "AWS_SSH_KEY_PRIVATE" {}


resource "aws_key_pair" "kp" {
  key_name   = "aws"
  public_key = var.AWS_SSH_KEY

}

#  resource "local_file" "tf_ansible_vars_file" {
#      content  = yamlencode(
#     {
#       public_ip = "${aws_eip.default[0].public_ip}"
#     }
#   )
#   filename = "${path.module}/files/docker-compose.tftpl"
# }


# data "template_file" "wireguard" {
#   template = "${file("${path.module}/files/docker-compose.tpl")}"
#   vars = {
#     public_ip = "${aws_eip.default[0].public_ip}"
#   }
# }

# data "template_file" "wireguard" {
#   #template = file(format("%s/files/docker-compose.tpl", path.module))
# template = file("files/docker-compose.tpl")
#    vars = {
#      public_ip = "${aws_eip.default[0].public_ip}"
#    }
# }

resource "aws_instance" "bastion" {
  depends_on = [aws_internet_gateway.gw]

  ami                                  = data.aws_ami.amazon-linux-2.id
  #instance_type                        = "t2.micro"
  instance_type                        = "t4g.micro"
  associate_public_ip_address          = true
  subnet_id                            = aws_subnet.public_subnets["az_a"].id
  instance_initiated_shutdown_behavior = "terminate"
  user_data                            = <<EOF
		#!/bin/bash
    yum install -y tree vim
	EOF
  root_block_device {
    #device_name           = "/dev/xvda"
    volume_size = 20
    volume_type = "standard"

  }
  ebs_block_device {
    delete_on_termination = false
    device_name           = "/dev/sdb"

    volume_size = 20
    #volume_type = "gp2"
    volume_type = "standard"
  }

  vpc_security_group_ids = [aws_security_group.bastion-01-sg.id]
  key_name               = aws_key_pair.kp.key_name

  # connection {
  #     user        = "ec2-user"
  #     private_key = "${tls_private_key.pk.private_key_pem}"
  #     agent       = false
  #     #host        = aws_instance.private_subnet.private_ip
  #     host        = aws_instance.bastion.public_ip
  #   }

  #   provisioner "file" {
  #     source      = "config"
  #     destination = "/tmp/config"
  #   }

provisioner "file" {
  #source      = "${path.module}/files/docker-compose.yml"
  #source      = templatefile("${path.module}/files/docker-compose.tftpl", { public_ip = "${aws_instance.bastion.public_ip}" })
  #source      = yamlencode(templatefile("${path.module}/files/docker-compose.tftpl", { public_ip = "${aws_eip.default[0].public_ip}" }))
  #source      = tostring(file("${path.module}/files/docker-compose.tpl"))
  #source       = data.template_file.wireguard.template
  #source      = local_file.tf_ansible_vars_file.filename
  
  #source      = 
  source       = var.wireguard_template
  destination = "/tmp/docker-compose.yml"

  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = var.AWS_SSH_KEY_PRIVATE
    host     = aws_instance.bastion.public_ip
  }
}
  tags = {
    Name              = "bastion-01"
    Stack             = "dev"
    Owner             = "Petro Bogdan"
    ansible_hostgroup = "wireguard"
  }
}

# data "http" "myip" {
#   url = "http://ipv4.icanhazip.com"
# }



resource "aws_security_group" "bastion-01-sg" {
  name        = "bastion-01-sg"
  description = "Bastion-01 Security Group"
  vpc_id      = aws_vpc.my-vpc-01.id

  ingress {
    description = "Petro Bogdan home IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "bastion-01"
    Stack = "dev"
    Owner = "Petro Bogdan"

  }
}
resource "aws_security_group" "private" {
  name        = "private-01-sg"
  description = "Private hosts Security Group"
  vpc_id      = aws_vpc.my-vpc-01.id

  ingress {
    description = "Petro Bogdan home IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["92.60.179.185/32"]
    #cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "private"
    Stack = "dev"
    Owner = "Petro Bogdan"

  }
}