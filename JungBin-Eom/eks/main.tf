terraform {
  backend "s3" {
    region         = "ap-northeast-2"
    bucket         = "dna-tfstates"
    key            = "dna-infra-states/aws-eks.tfstate"
    profile        = "ricky-mfa"
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

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    encrypt = true
    region  = "ap-northeast-2"
    bucket  = "dna-tfstates"
    key     = "dna-infra-states/aws-vpc.tfstate"
    profile = "ricky-mfa"
  }
}

locals {
  cluster_name = "dna-test-${var.aws_region}"
  common_tags = {
    Owner = "dna-Jarvis"
  }
}
