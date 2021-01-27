resource "aws_instance" "web" {
  #creating an EC2 instance based on packer AMI
  ami           = "ami-0f11fc02196137199"
  instance_type = "t2.micro"

  tags = {
    Name = "Using Packer AMI"
  }
}