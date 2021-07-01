locals {
  public_subnets = {
    az_a = {
      name              = "my-dev-01-sub-pub-a"
      cidr_block        = "172.16.1.0/24"
      availability_zone = "us-east-1a"
    },
    az_b = {
      name              = "my-dev-01-sub-pub-b"
      cidr_block        = "172.16.3.0/24"
      availability_zone = "us-east-1b"
    },
    az_c = {
      name              = "my-dev-01-sub-pub-c"
      cidr_block        = "172.16.5.0/24"
      availability_zone = "us-east-1c"
    },
  }
  private_subnets = {
    az_a = {
      name              = "my-dev-01-sub-priv-a"
      cidr_block        = "172.16.2.0/24"
      availability_zone = "us-east-1a"
    },
    az_b = {
      name              = "my-dev-01-sub-priv-b"
      cidr_block        = "172.16.4.0/24"
      availability_zone = "us-east-1b"
    },
    az_c = {
      name              = "my-dev-01-sub-priv-c"
      cidr_block        = "172.16.6.0/24"
      availability_zone = "us-east-1c"
    },
  }
  nat_gateways = {
    public_gw1 = {
      name = "my-dev-01-natgw-a"
      #subnet  = "${aws_subnet.public_subnets["az_a"]}"
      subnet        = "${aws_subnet.public_subnets["az_a"].id}"
      allocation_id = "${aws_eip.default[0].id}"
    },
    public_gw2 = {
      name = "my-dev-01-natgw-b"
      #subnet  = "${aws_subnet.public_subnets["az_b"]}"
      subnet        = "${aws_subnet.public_subnets["az_b"].id}"
      allocation_id = "${aws_eip.default[1].id}"

    },
    public_gw3 = {
      name = "my-dev-01-natgw-c"
      #subnet  = "${aws_subnet.public_subnets["az_c"]}"
      subnet        = "${aws_subnet.public_subnets["az_c"].id}"
      allocation_id = "${aws_eip.default[2].id}"

    },
  }

  routes_private = {
    rt1_priv = {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = "${aws_nat_gateway.public_subnets["public_gw1"].id}"
      name           = "my-dev-01-sub-priv-a"
    },
    rt2_priv = {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = "${aws_nat_gateway.public_subnets["public_gw2"].id}"
      name           = "my-dev-01-sub-priv-b"
    },
    rt3_priv = {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = "${aws_nat_gateway.public_subnets["public_gw3"].id}"
      name           = "my-dev-01-sub-priv-c"
    },
  }
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

resource "aws_subnet" "private_subnets" {
  for_each          = local.private_subnets
  vpc_id            = aws_vpc.my-vpc-01.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags = {
    Name = "${each.value.name}"
  }
}

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

resource "aws_route_table" "private" {
  vpc_id   = aws_vpc.my-vpc-01.id
  for_each = local.routes_private
  route {
    cidr_block = each.value.cidr_block
    gateway_id = each.value.nat_gateway_id
  }
  tags = {
    Name = "${each.value.name}"
  }

}

resource "aws_eip" "default" {
  count      = 3
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "public_subnets" {
  for_each      = local.nat_gateways
  subnet_id     = each.value.subnet
  allocation_id = each.value.allocation_id
  //connectivity_type default public
  tags = {
    Name = "${each.value.name}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

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
    values = ["amzn2-ami-hvm*"]
  }
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
  # algorithm = "ECDSA"
  # ecdsa_curve = "P384"
}

resource "aws_key_pair" "kp" {
  key_name   = "lab2"       # Create a "myKey" to AWS!!
  public_key = tls_private_key.pk.public_key_openssh

  # provisioner "local-exec" { # Create a "myKey.pem" to your computer!!
  #   #&& chmod 400 ./lab2.pem
  #   command = "echo '${tls_private_key.pk.private_key_pem}' > ./lab2.pem && chmod 400 ./lab2.pem"
  # }
}

resource "local_file" "private_key" {
    content  = tls_private_key.pk.private_key_pem
    filename = "lab2.pem"
    file_permission = "0400"
}


resource "aws_instance" "bastion" {
  depends_on = [aws_internet_gateway.gw]

  ami                                  = data.aws_ami.amazon-linux-2.id
  instance_type                        = "t2.micro"
  associate_public_ip_address          = true
  subnet_id                            = aws_subnet.public_subnets["az_c"].id
  instance_initiated_shutdown_behavior = "terminate"
  user_data                            = <<EOF
		#!/bin/bash
    yum install -y tree
	EOF
  root_block_device {
    #device_name           = "/dev/xvda"
    volume_size = 20
    volume_type = "gp2"

  }
  ebs_block_device {
    delete_on_termination = false
    device_name           = "/dev/sdb"

    volume_size = 40
    volume_type = "gp2"
  }

vpc_security_group_ids = [aws_security_group.bastion-01-sg.id]
key_name = aws_key_pair.kp.key_name

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

  tags = {
    Name  = "bastion-01"
    Stack = "dev"
    Owner = "Petro Bogdan"
  }
}

resource "aws_instance" "private_subnet" {
  depends_on = [aws_internet_gateway.gw]

  ami                                  = data.aws_ami.amazon-linux-2.id
  instance_type                        = "t2.micro"
  subnet_id                            = aws_subnet.private_subnets["az_b"].id
  instance_initiated_shutdown_behavior = "terminate"

vpc_security_group_ids = [aws_security_group.private.id]
key_name = aws_key_pair.kp.key_name


  # provisioner "remote-exec" {
  #   inline = [
  #     "cat /tmp/config.sh |tee -a > /home/ec2_user/.ssh/config"
  #   ]
  # }
# provisioner "file" {
#     source      = "./config"
#     destination = "/home/ec2_user/.ssh/config"
#   }
#   connection {
#     type     = "ssh"
#     user     = "ec2_user"
#     private_key = file("lab2.pem")
#     host     = aws_instance.private_subnet.public_ip
#   }


  tags = {
    Name  = "private-host"
  }
}



data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "bastion-01-sg" {
  name        = "bastion-01-sg"
  description = "Bastion-01 Security Group"
  vpc_id      = aws_vpc.my-vpc-01.id

  ingress {
    description = "Petro Bogdan home IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    #cidr_blocks = ["92.60.179.185/32"]
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]

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
    #cidr_blocks = ["92.60.179.185/32"]
    cidr_blocks = ["0.0.0.0/0"]

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