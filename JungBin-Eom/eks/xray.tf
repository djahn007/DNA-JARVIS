module "iam_assumable_role_xray" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "4.2.0"

  create_role  = true
  role_name    = "${local.cluster_name}-xray-daemon"
  provider_url = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns = [
    "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
  ]
}
