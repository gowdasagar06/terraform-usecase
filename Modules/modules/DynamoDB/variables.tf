variable "region" {
  description = "AWS region"
  type        = string
}

variable "table_name" {
  description = "Name for the DynamoDB table"
  type        = string
}

variable "hash_key" {
  description = "Hash key for the DynamoDB table"
  type        = string
}