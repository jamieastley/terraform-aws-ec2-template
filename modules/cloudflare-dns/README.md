# Cloudflare-dns

A submodule that can be used alongside the primary module to create a Cloudflare DNS record for the
provisioned resource.

## Usage

The module requires the following environment variables to be set:

| Variable                    | Description                                         |
|-----------------------------|-----------------------------------------------------|
| `CLOUDFLARE_API_TOKEN`      | The Cloudflare API token to use for authentication. |
| `TF_VAR_cloudflare_zone_id` | The Cloudflare zone ID to create the record in.     |
| `TF_VAR_name`               | The DNS record name to create.                      |


