provider "aws" {
  region = "ap-south-1"
}
resource "aws_instance" "ec2" {
  ami             = "ami-03f4878755434977f"
  instance_type   = "t2.micro"
  subnet_id       = data.aws_subnet.existing_subnet.id
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]
  key_name = data.aws_key_pair.existing_key_pair.key_name
  associate_public_ip_address = true
}

# terraform taint aws_instance.ec2
