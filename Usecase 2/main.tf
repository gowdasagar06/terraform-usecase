provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
    tags = {
    Name = "vpc-test-tf"
  }
}

resource "aws_subnet" "public_subnet" {
  count = 3

  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  availability_zone       = element(["ap-south-1a", "ap-south-1b", "ap-south-1c"], count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "pubsubnet${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count = 3

  vpc_id         = aws_vpc.main.id
  cidr_block     = "10.0.${count.index + 4}.0/24"
  availability_zone = element(["ap-south-1a", "ap-south-1b", "ap-south-1c"], count.index)

  tags = {
    Name = "pvtsubnet${count.index + 1}"
  }
}

resource "aws_subnet" "database_subnet" {
  count = 3

  vpc_id         = aws_vpc.main.id
  cidr_block     = "10.0.${count.index + 7}.0/24"
  availability_zone = element(["ap-south-1a", "ap-south-1b", "ap-south-1c"], count.index)

  tags = {
    Name = "dbsubnet${count.index + 1}"
  }
}

data "aws_iam_policy" "cloud-watch-policy" {
  name = "CloudWatchFullAccess" //this AWS managed policy
}

resource "aws_flow_log" "vpc_flow_logs" {
  count                   = length(aws_subnet.public_subnet)
  iam_role_arn            = aws_iam_role.flow_logs.arn
  log_destination         = "arn:aws:logs:ap-south-1:528462248584:log-group:demo"
  traffic_type            = "ALL"
  max_aggregation_interval = 60

  subnet_id = aws_subnet.public_subnet[count.index].id
}

resource "aws_iam_role" "flow_logs" {
  name = "flow-logs-role"
  managed_policy_arns = [ data.aws_iam_policy.cloud-watch-policy.arn ]
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
    tags = {
    Name = "igw-test-tf"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_rta" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}


output "vpc_id" {
  value = aws_vpc.main.id
}
output "subnet_pub_info" {
  value = [
    for subnet in aws_subnet.public_subnet : {
      subnet_id         = subnet.id
      subnet_cidr_block = subnet.cidr_block
      subnet_availability_zone = subnet.availability_zone
      subnet_tags       = subnet.tags
    }
  ]
}
output "subnet_private_info" {
  value = [
    for subnet in aws_subnet.private_subnet : {
      subnet_id         = subnet.id
      subnet_cidr_block = subnet.cidr_block
      subnet_availability_zone = subnet.availability_zone
      subnet_tags       = subnet.tags
    }
  ]
}
output "subnet_database_info" {
  value = [
    for subnet in aws_subnet.database_subnet : {
      subnet_id         = subnet.id
      subnet_cidr_block = subnet.cidr_block
      subnet_availability_zone = subnet.availability_zone
      subnet_tags       = subnet.tags
    }
  ]
}
