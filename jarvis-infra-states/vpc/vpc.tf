locals {
  name = "jarvis-vpc"

  acl_policy_allow_all = {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name                  = local.name
  cidr                  = var.vpc_cidrs[0]
  secondary_cidr_blocks = slice(var.vpc_cidrs, 1, length(var.vpc_cidrs))
  azs                   = slice(data.aws_availability_zones.available.names, 0, 3)

  public_subnets  = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs

  public_subnet_tags = {
    network                  = "Public",
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    network                           = "Private",
    "kubernetes.io/role/internal-elb" = 1
  }

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  default_security_group_name    = "jarvis-vpc-sg-default"
  default_security_group_ingress = []
  default_security_group_egress  = []
  manage_default_security_group  = true

  default_network_acl_name    = "jarvis-vpc-acl-default"
  default_network_acl_ingress = [local.acl_policy_allow_all]
  default_network_acl_egress  = [local.acl_policy_allow_all]
  manage_default_network_acl  = true

  manage_default_route_table = true
}
