
variable "region" {
  description = "AWS region"
  type        = string
}

variable "ami" {
  description = "AMI ID for instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "instance_count" {
  description = "Number of instances"
  type        = number
}

#terraform workspace new dev
#terraform workspace new prod
#terraform workspace select dev
# terraform apply -var 'region=ap-south-1' -var 'ami=ami-03f4878755434977f' -var 'instance_type=t3.micro' -var 'instance_count=1'
#terraform workspace select prod
# terraform apply -var 'region=us-west-1' -var 'ami=ami-03f48787552383093a' -var 'instance_type=t3.large' -var 'instance_count=3'