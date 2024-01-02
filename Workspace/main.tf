
provider "aws" {
    region = var.region
}
resource "aws_instance" "example" {
  ami           = var.ami
  instance_type = var.instance_type
  count         = var.instance_count
  //ami           = "ami-0287a05f0ef0e9d9a"
  vpc_security_group_ids = ["sg-06c48217addbba097"]  
  subnet_id              = "subnet-0ad217e6c10b9c633"  
  key_name = "gowda"

}
