provider "aws" {
  region  = "ap-northeast-2"
  profile = "ricky-mfa"
}

# S3 bucket for backend
resource "aws_s3_bucket" "tfstate" {
  bucket = "dna-tfstates"

  versioning {
    enabled = true
  }
}

# DynamoDB for terraform state lock
resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "terraform-lock"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}
