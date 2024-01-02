
data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name"
    values = ["demo-vpc"]
  }
}

data "aws_subnet" "existing_subnet" {
  filter {
    name   = "tag:Name"
    values = ["demo-Pub"]
  }
}
data "aws_security_group" "existing_sg" {
  filter {
    name   = "tag:Name"
    values = ["pub-sg"]
  }
}

data "aws_key_pair" "existing_key_pair" {
  key_name = "gowdasagar" 
}

output "existing_subnet_id" {
  value = data.aws_subnet.existing_subnet.id
}

output "existing_sg_id" {
  value = data.aws_security_group.existing_sg.id
}
output "existing_key_pair" {
  value = data.aws_key_pair.existing_key_pair.key_name
}