variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}
variable "az_names" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}

variable "public_subnet_cidr" {
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidr" {
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "ami" {
  type        = string
  default     = "ami-0a0f1259dd1c90938"
}

variable "aws_region" {
  type        = string
  default     = "ap-south-1"
  }

variable "server_port" {
  type        = number
  default     = 8080
}

variable "elb_port" {
  type        = number
  default     = 80
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
}

variable "min_size" {
  type        = number
  default     = 1
}

variable "max_size" {
  type        = number
  default     = 3
}

variable "desired_capacity" {
  type        = number
  default     = 2
}


variable "vpc_name" {
  type        = string
  default     = "sagar-vnet"
}

variable "internet_gateway_name" {
  type        = string
  default     = "sagar-internet-gateway"
}

variable "public_subnet_name" {
  type        = string
  default     = "sagar-public-subnet"
}

variable "private_subnet_name" {
  type        = string
  default     = "sagar-private-subnet"
}

variable "public_route_table_name" {
  type        = string
  default     = "sagar-public-route-table"
}

variable "private_route_table_name" {
  type        = string
  default     = "sagar-private-route-table"
}

variable "elastic_ip_name" {
  type        = string
  default     = "sagar-nat-elastic-ip"
}

variable "nat_gateway_name" {
  type        = string
  default     = "sagar-nat-gateway"
}

variable "alb_security_group_name" {
  type        = string
  default     = "sagar-alb-security-group"
}

variable "asg_security_group_name" {
  type        = string
  default     = "sagar-asg-security-group"
}

variable "launch_template_name" {
  type        = string
  default     = "sagar-launch-template"
}

variable "launch_template_ec2_name" {
  type        = string
  default     = "sagar-asg-ec2"
}

variable "alb_name" {
  type        = string
  default     = "sagar-external-alb"
}

variable "target_group_name" {
  type        = string
  default     = "sagar-alb-target-group"
}

