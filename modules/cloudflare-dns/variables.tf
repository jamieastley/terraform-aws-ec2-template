variable "name" {
  type        = string
  description = "The DNS record name"
}

variable "zone_id" {
  type        = string
  description = "The ID of the DNS zone"
}

variable "proxied" {
  type        = bool
  default     = true
  description = "Whether the DNS record is proxied by Cloudflare"
}

variable "value" {
  type        = string
  description = "The value of the DNS record"
}