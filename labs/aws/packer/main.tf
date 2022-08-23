resource "aws_instance" "web" {
  #creating an EC2 instance based on packer AMI
  ami           = "ami-0f11fc02196137199"
  instance_type = "t2.micro"

root_block_device {
      encrypted = true
  }

  ebs_block_device {
    device_name = "/dev/sdg"
    volume_size = 5
    volume_type = "gp2"
    delete_on_termination = false
    encrypted = true
  }
  tags = {
    Name = "Using Packer AMI"
  }
}