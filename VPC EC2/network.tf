resource "aws_vpc" "vpc-tf" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = var.vpc
  }
}
resource "aws_subnet" "subnet-tf" {
  vpc_id     = aws_vpc.vpc-tf.id
  for_each = var.subnet
  cidr_block = each.value["cidr"]
  availability_zone = each.value["azs"]

  tags = {
    Name = each.value["name"]
  }
}
resource "aws_internet_gateway" "igw-tf" {
  vpc_id = aws_vpc.vpc-tf.id
  tags = {
    Name = "igw-tf"
  }
}
resource "aws_route_table" "pub-rt-tf" {
  vpc_id = aws_vpc.vpc-tf.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/32"
    gateway_id = aws_internet_gateway.igw-tf.id
  }

  tags = {
    Name = "pub-rt-tf"
  }
}
# resource "aws_route_table" "private-rt-tf" {
#   vpc_id = aws_vpc.vpc-tf.id

#   route {
#     cidr_block = "10.0.2.0/24"
#     gateway_id = "local"
#   }

#   tags = {
#     Name = "private-rt-tf"
#   }
# }

resource "aws_route_table_association" "rta-tf" {
    for_each = aws_subnet.subnet-tf
  subnet_id              = each.value.id
  route_table_id = aws_route_table.pub-rt-tf.id
}

resource "aws_security_group" "sg-tf" {
  vpc_id= aws_vpc.vpc-tf.id
  dynamic "ingress" {
    for_each = var.sg_ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]

    }
}