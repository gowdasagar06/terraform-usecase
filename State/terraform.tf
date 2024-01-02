terraform {
  backend "s3" {
    bucket         = "terraform-sagar-s3-bucket-name"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}