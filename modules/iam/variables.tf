locals {
  resource_prefix = "${var.app_name}-${var.environment}"
}

locals {
  tags = {
    Name        = local.resource_prefix
    Environment = var.environment
  }
}

variable "environment" {
  description = "The environment in which the EC2 instance will be provisioned. Value will also be applied as tag to each resource."
  type        = string
  default     = "dev"
}

variable "app_name" {
  description = "The name of the app service that's being deployed. Name will be concatenated into resource names"
  type        = string
  nullable    = false
}

variable "aws_region" {
  description = "The AWS region in which the resources will be provisioned"
  type        = string
  default     = "ap-southeast-2"
}

variable "aws_account_id" {
  description = "The AWS account ID in which the resources will be provisioned"
  type        = string
  sensitive   = true
}

variable "s3_bucket_name" {
  description = "The name of the bucket which will be added to the policy"
  type        = string
  sensitive   = true
}

variable "oidc_subjects" {
  description = "The subjects for the OIDC provider"
  type        = list(string)
}