module "S3" {
  region     = "ap-south-1"
  source      = "./modules/S3"
  bucket_name = var.bucket_name
}
module "VPC" {
  region     = "ap-south-1"
  source     = "./modules/VPC"
  cidr_block = var.cidr_block
}
module "DynamoDB" {
  region     = "ap-south-1"
  source     = "./modules/DynamoDB"
  table_name = var.table_name
  hash_key   = var.hash_key
}