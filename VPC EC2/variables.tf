variable "vpc" {
    type = string
    default = "vpc-tf"
}
variable "subnet" {
    type = map(object(
        {
            name = string
            cidr = string
            azs = string
        }
    ))
  default = {
    subnet-1={
        name = "sagar-pub-subnet-tf"
        cidr = "10.0.1.0/24"
        azs = "ap-south-1a"
    }
    subnet-2={
        name = "sagar-private-subnet-tf"
        cidr = "10.0.2.0/24"
        azs = "ap-south-1b"
    }    
  }
}
variable "sg_ports" {
  type        = list(number)
  default     = [22, 80, 8080]
} 
variable "instance_type" {
    type = list
    default = ["t2.micro", "t3.micro"]
  
}
variable "ami"{
    type = string
    default = "ami-0287a05f0ef0e9d9a"
}