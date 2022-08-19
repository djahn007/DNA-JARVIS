terraform {
  backend "s3" {
    region         = "ap-northeast-2"
    bucket         = "jarvis-tfstates"
    key            = "jarvis-infra-states/aws-vpc.tfstate"
    profile        = "jarvis"
    dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
  profile = var.profile
  region  = var.aws_region
}

data "aws_availability_zones" "available" {
  state = "available"
}
