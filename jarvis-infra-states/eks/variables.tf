variable "account_id" {
  type        = string
  description = "aws account id"
}

variable "profile" {
  type        = string
  description = "aws profile (yor mfa profile name)"
}

variable "aws_region" {
  type        = string
  description = "aws region"
}

variable "cluster_enabled_log_types" {
  type    = list(string)
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "instance_types" {
  type        = list(string)
  description = "node instance types"
}

variable "create_coredns" {
  type        = bool
  description = "Create Coredns"
  default     = true
}

variable "coredns_version" {
  type        = string
  description = "The EKS Coredns version"
  default     = "v1.8.7-eksbuild.1"
}

variable "create_kube_proxy" {
  type        = bool
  description = "Create kube-proxy"
  default     = true
}

variable "kube_proxy_version" {
  type        = string
  description = "The EKS kube-proxy version"
  default     = "v1.22.6-eksbuild.1"
}

variable "create_vpc_cni" {
  type        = bool
  description = "Create vpc-cni"
  default     = true
}

variable "vpc_cni_version" {
  type        = string
  description = "The EKS vpc-cni version"
  default     = "v1.11.0-eksbuild.1"
}
