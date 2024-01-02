
provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "tf-vpc" {
  cidr_block           = "10.2.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "tf-vpc"
  }
}

resource "aws_subnet" "tf-pub-subnet" {
  vpc_id            = aws_vpc.tf-vpc.id
  availability_zone = "ap-south-1a"
  cidr_block        = "10.2.1.0/24"

  tags = {
    Name = "tf-subnet"
  }
}

resource "aws_internet_gateway" "tf-igw" {
  vpc_id = aws_vpc.tf-vpc.id
}

resource "aws_route_table" "tf-pub-rt" {
  vpc_id = aws_vpc.tf-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf-igw.id
  }

  tags = {
    Name = "tf-public-crt"
  }
}

resource "aws_route_table_association" "tf-rta" {
  route_table_id = aws_route_table.tf-pub-rt.id
  subnet_id      = aws_subnet.tf-pub-subnet.id
}

//create the network interface
resource "aws_network_interface" "test-interface"{
    subnet_id = aws_subnet.tf-pub-subnet.id
    private_ips = [ "10.2.1.10" ]
    security_groups = [ aws_security_group.dynamic-ssh-http-sg.id ]
}

//allocate the EIP
resource "aws_eip" "eip-test" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.test-interface.id
  associate_with_private_ip = "10.2.1.10"
}

resource "aws_security_group" "dynamic-ssh-http-sg" {
  vpc_id = aws_vpc.tf-vpc.id

  dynamic "ingress" {
    for_each = [22, 80]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dynamic-ssh-http-sg"
  }
}
resource "aws_instance" "ec2_with_eip" {
  ami                    = "ami-03f4878755434977f"
  instance_type          = "t2.micro"
  key_name               = "gowdasagar"
  //subnet_id              = aws_subnet.tf-pub-subnet.id
  //associate_public_ip_address = false
  //vpc_security_group_ids = [aws_security_group.dynamic-ssh-http-sg.id]

  tags = {
    Name = "nginx-instance-with-eip"
  }

  root_block_device {
    volume_size = 8
    encrypted   = true
  }
  network_interface {
    network_interface_id = aws_network_interface.test-interface.id
    device_index = 0
  }

  lifecycle {
    create_before_destroy = true
  }
   provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("./gowdasagar.pem")
      host        = self.public_ip
    }
  }
}


# //allocate the elastic ip
# resource "aws_eip" "elastic-ip"{
#     instance = aws_instance.ec2_with_eip.id
#     domain = "vpc"
# }


# outputs.tf

output "instance_id" {
  value = aws_instance.ec2_with_eip.id
}

output "vpc" {
  value = aws_vpc.tf-vpc.id
}

output "subnet" {
  value = aws_subnet.tf-pub-subnet.id
}

output "aws_internet_gateway" {
  value = aws_internet_gateway.tf-igw.id
}

output "aws_route_table" {
  value = aws_route_table.tf-pub-rt.id
}

output "aws_security_group" {
  value = aws_security_group.dynamic-ssh-http-sg.id
}
output "aws_eip" {
  value = aws_eip.eip-test.public_ip
}
