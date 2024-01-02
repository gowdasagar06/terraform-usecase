terraform {
  backend "s3" {
    bucket         = "terraform-sagar-s3-bucket-name111"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-lock1"
  }
}