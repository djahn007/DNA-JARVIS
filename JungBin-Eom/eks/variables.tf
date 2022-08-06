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
