variable "profile" {
  type        = string
  description = "aws profile (yor mfa profile name)"
}

variable "aws_region" {
  type        = string
  default     = "ap-northeast-2"
  description = "aws region (default is 'ap-northeast-2')"
}

variable "vpc_cidrs" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "all vpc cidrs, max item count is 1"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.0.0/19", "10.0.32.0/19"]
  description = "public subnets cidr list"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.64.0/19", "10.0.96.0/19"]
  description = "private subnets cidr list"
}
