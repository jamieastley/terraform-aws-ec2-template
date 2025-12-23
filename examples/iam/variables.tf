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
  description = "The name of the S3 bucket to be created"
  type        = string
  sensitive   = true
}

variable "organisation_name" {
  description = "The organisation name"
  type        = string
}

variable "repository_name" {
  description = "The environment name"
  type        = string
}
