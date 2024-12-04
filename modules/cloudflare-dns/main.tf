terraform {
  required_version = ">= 1.10.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.47.0"
    }
  }
}

resource "cloudflare_record" "dns_record" {
  name    = var.name
  type    = "A"
  proxied = var.proxied
  zone_id = var.zone_id
  value   = var.value
}