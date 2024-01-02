provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "s3" {
  bucket = "terraform-sagar-s3-bucket-name"
  acl    = "private"
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
resource "aws_dynamodb_table" "dy" {
  name           = "terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

# resource "aws_instance" "ec2" {
#   ami             = "ami-03f4878755434977f"
#   instance_type   = "t2.micro"
#   subnet_id       = data.aws_subnet.existing_subnet.id
#   vpc_security_group_ids = [data.aws_security_group.existing_sg.id]
#   key_name = data.aws_key_pair.existing_key_pair.key_name
#   associate_public_ip_address = true
# }

# data "aws_vpc" "existing_vpc" {
#   filter {
#     name   = "tag:Name"
#     values = ["demo-vpc"]
#   }
# }

# data "aws_subnet" "existing_subnet" {
#   filter {
#     name   = "tag:Name"
#     values = ["demo-Pub"]
#   }
# }
# data "aws_security_group" "existing_sg" {
#   filter {
#     name   = "tag:Name"
#     values = ["pub-sg"]
#   }
# }

# data "aws_key_pair" "existing_key_pair" {
#   key_name = "gowdasagar" 
# }
# output "existing_subnet_id" {
#   value = data.aws_subnet.existing_subnet.id
# }

# output "existing_sg_id" {
#   value = data.aws_security_group.existing_sg.id
# }
# output "existing_key_pair" {
#   value = data.aws_key_pair.existing_key_pair.key_name
# }