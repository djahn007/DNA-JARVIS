module "iam_assumable_role_cloudwatch_agent_role" {
  source       = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version      = "4.2.0"
  create_role  = true
  role_name    = "${local.cluster_name}-cloudwatch-agent"
  provider_url = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]
}

module "iam_assumable_role_cloudwatch_grafana_role" {
  source       = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version      = "4.2.0"
  create_role  = true
  role_name    = "${local.cluster_name}-cloudwatch-grafana"
  provider_url = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
  ]
}
