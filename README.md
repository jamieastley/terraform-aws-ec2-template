# terraform-aws-ec2-template

A reusable Terraform module to create an EC2 instance in AWS, and group to an application dashboard.

## Getting Started

See the `example` directory for a working demo of the module.

## CloudFlare R2 Backend Support

This module supports using CloudFlare R2 as a Terraform backend. See [R2_BACKEND.md](./R2_BACKEND.md) for detailed instructions on how to configure:
- CloudFlare R2 as the Terraform state backend
- Separate AWS credentials for local development (using AWS profiles)
- AWS OIDC authentication for GitHub Actions/CI-CD

Note: This README is a work in progress and will be updated as the module is developed further and
in a state I'm happy with.