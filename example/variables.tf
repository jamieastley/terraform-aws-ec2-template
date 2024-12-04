variable "is_local_debug" {
  type        = bool
  default     = true
  description = "Sets whether the module is being run in local debug mode"
}

variable "cloudflare_zone_id" {
  type        = string
  description = "The Cloudflare zone ID"
}