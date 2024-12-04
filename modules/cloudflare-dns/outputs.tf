output "hostname" {
  value       = cloudflare_record.dns_record.hostname
  description = "The hostname of the DNS record"
}