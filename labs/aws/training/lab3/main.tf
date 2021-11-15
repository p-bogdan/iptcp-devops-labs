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
    az_d = {
      name              = "my-dev-01-sub-pub-d"
      cidr_block        = "172.16.7.0/24"
      availability_zone = "us-east-1d"
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
  depends_on = [aws_vpc.my-vpc-01]
  tags = {
    Name = "${each.value.name}"
  }
}

resource "aws_security_group" "EC2-sg" {
  
  name        = "EC2-sg"
  description = "SSH connection"
  vpc_id      = aws_vpc.my-vpc-01.id
  depends_on = [aws_vpc.my-vpc-01]
  ingress {
    description = "Petro Bogdan home IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
    #cidr_blocks = ["92.60.179.185/32"]
    #cidr_blocks = ["${chomp(data.http.myip.body)}/32"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "EC2-sg"
    Owner = "Petro Bogdan"

  }
}
resource "aws_security_group" "EFS-sg" {
  name        = "EFS-sg"
  description = "Allow only EC2"
  vpc_id      = aws_vpc.my-vpc-01.id
  depends_on = [aws_vpc.my-vpc-01, aws_security_group.EC2-sg]
  ingress {
    description = "Petro Bogdan home IP"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    #cidr_blocks = ["92.60.179.185/32"]
    #cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.EC2-sg.id]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "EFS-sg"
    Owner = "Petro Bogdan"

  }
}

# resource "aws_efs_file_system" "efs-example" {
#    creation_token = "efs-example"
#    performance_mode = "generalPurpose"
#    throughput_mode = "bursting"
#    #encrypted = "true"
#  tags = {
#      Name = "EfsExample"
#    }
#  }

#  resource "aws_efs_mount_target" "efs-mt-example" {
#    file_system_id  = "${aws_efs_file_system.efs-example.id}"
#    subnet_id = "${aws_subnet.subnet-efs.id}"
#    security_groups = ["${aws_security_group.ingress-efs.id}"]
#  }