variable "is_local_debug" {
  type        = bool
  default     = true
  description = "Sets whether the module is being run in local debug mode"
}

variable "cloudflare_zone_id" {
  type        = string
  description = "The Cloudflare zone ID"
}

variable "ec2_public_key" {
  description = "The public key to use for the EC2 instance"
  type        = string
  nullable    = false
  sensitive   = true
}

variable "aws_profile" {
  description = "AWS CLI profile name to use for authentication. Set this for local development. Leave null for CI/CD with OIDC."
  type        = string
  default     = null
}

variable "aws_region" {
  description = "AWS region for provider configuration"
  type        = string
  default     = "us-east-1"
}
