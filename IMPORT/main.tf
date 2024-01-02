
resource "aws_instance" "name" {
    ami = "ami-0287a05f0ef0e9d9a"
    instance_type = "t3.micro"
    associate_public_ip_address = true
    subnet_id = aws_subnet.tf-pub-subnet.id
    vpc_security_group_ids = ["${aws_security_group.ssh-sg.id}"]
    key_name = "gowda" 
}
resource "aws_instance" "ssss" {
    ami = "ami-0a0f1259dd1c90938"
    instance_type = "t2.micro"
    associate_public_ip_address = true
    subnet_id = aws_subnet.tf-pub-subnet.id
    vpc_security_group_ids = ["${aws_security_group.ssh-sg.id}"]
    key_name = "gowda" 
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
    subnet_id = aws_subnet.tf-pub-subnet.id
  
}
resource "aws_security_group" "ssh-sg" {
    vpc_id = aws_vpc.tf-vpc.id
    ingress {
        from_port=22
        to_port=22
        protocol="tcp"
        cidr_blocks = ["0.0.0.0/0"]
        
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]

    }
 ingress {
        from_port=80
        to_port=80
        protocol="tcp"
        cidr_blocks = ["0.0.0.0/0"]
        
    }
     tags = {
    Name = "ssh-allowed"
  }
}
resource "aws_vpc" "tf-vpc" {
    cidr_block = "10.2.0.0/16"
    enable_dns_hostnames = true
      tags = {
    Name = "tf-vpc"
  }
}
resource "aws_subnet" "tf-pub-subnet" {
        vpc_id = aws_vpc.tf-vpc.id
        availability_zone = "ap-south-1a"
        cidr_block = "10.2.1.0/24"
        tags = {
          Name ="tf-subnet"
        }
}