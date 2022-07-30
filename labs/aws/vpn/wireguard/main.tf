# Lookup a reference to the owning VPC in which all our subnets are located
data "aws_vpc" "vpc" {
  filter {
    name = "tag:Name"
    values = [var.vpc_name] # Let's assume this is "foo"
  }
}

# Lookup the "Public" subnet in which our WireGuard instance should be placed
data "aws_subnet_ids" "public_subnet_ids" {
  filter {
    name = "tag:Name"
    values = [var.vpc_subnet_name]
  }
  vpc_id = data.aws_vpc.vpc.id
}