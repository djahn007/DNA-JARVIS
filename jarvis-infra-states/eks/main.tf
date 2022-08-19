terraform {
  backend "s3" {
    region         = "ap-northeast-2"
    bucket         = "jarvis-tfstates"
    key            = "jarvis-infra-states/aws-eks.tfstate"
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

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    encrypt = true
    region  = "ap-northeast-2"
    bucket  = "jarvis-tfstates"
    key     = "jarvis-infra-states/aws-vpc.tfstate"
    profile = "jarvis"
  }
}

locals {
  cluster_name = "jarvis-${var.aws_region}"
  common_tags = {
    Owner = "dna-jarvis"
  }
}
