module "default_nodes" {
  source  = "registry.terraform.io/terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "v18.20.5"
  count   = length(data.terraform_remote_state.vpc.outputs.public_subnet_ids)

  name            = "default-node-group-${count.index}"
  use_name_prefix = false

  cluster_name    = local.cluster_name
  cluster_version = "1.22"

  labels = {
    nodeType   = "default"
    nodeSubnet = "public"
  }

  min_size     = 1
  max_size     = 5
  desired_size = 2

  # EKS Managed Node Settings
  ami_type       = "AL2_x86_64"
  instance_types = var.instance_types
  capacity_type  = "ON_DEMAND"

  # Launch Template Settings
  bootstrap_extra_args = "--registry-qps=20 --registry-burst=40"
  block_device_mappings = [
    {
      device_name = "/dev/xvda"
      ebs = [
        {
          volume_size           = 128
          volume_type           = "gp3"
          delete_on_termination = true
        }
      ]
    }
  ]

  vpc_id                 = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids             = [data.terraform_remote_state.vpc.outputs.public_subnet_ids[count.index]]
  vpc_security_group_ids = [module.eks.node_security_group_id, aws_security_group.cluster_access.id]

  create_security_group = false
  create_iam_role       = false
  iam_role_arn          = aws_iam_role.managednode.arn

  tags = local.common_tags

  depends_on = [module.eks]
}
