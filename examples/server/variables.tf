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
