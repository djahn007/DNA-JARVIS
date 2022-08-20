module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_version           = "1.22"
  cluster_name              = local.cluster_name
  cluster_enabled_log_types = var.cluster_enabled_log_types

  create_cloudwatch_log_group = false
  create_iam_role             = false
  iam_role_arn                = aws_iam_role.eks_admin.arn

  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = concat(data.terraform_remote_state.vpc.outputs.public_subnet_ids, data.terraform_remote_state.vpc.outputs.private_subnet_ids)

  cluster_addons = {
    coredns = {
      version           = "v1.8.4-eksbuild.1"
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {
      version = "v1.21.2-eksbuild.2"
    }
    vpc-cni = {
      version           = "v1.10.1-eksbuild.1"
      resolve_conflicts = "OVERWRITE"
    }
  }

  tags = merge({
    SubWorkspace = "eks-cluster"
  }, local.common_tags)


  depends_on = [
    aws_iam_role.eks_admin
  ]
}
