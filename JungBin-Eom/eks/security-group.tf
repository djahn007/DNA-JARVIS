resource "aws_security_group" "cluster_access" {
  name        = "${local.cluster_name}-cluster-access-sg"
  description = "Security group for ${local.cluster_name} cluster access"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name         = "${local.cluster_name}-access-sg"
    SubWorkspace = "security-group"
  }, local.common_tags)
}
