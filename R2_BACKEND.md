# Using CloudFlare R2 as Terraform Backend

This guide explains how to configure this Terraform module to use CloudFlare R2 as the backend for state storage while maintaining proper authentication with AWS for resource provisioning.

## The Challenge

CloudFlare R2 uses an S3-compatible API and reads credentials from the same environment variables as AWS:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

This creates a conflict when both the Terraform backend (R2) and the AWS provider need different credentials.

## Solution Overview

The solution is to separate authentication methods:
1. **Backend (CloudFlare R2)**: Uses environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` (R2 credentials)
2. **AWS Provider**: Uses either:
   - AWS CLI named profile (local development)
   - OIDC/IAM roles (GitHub Actions/CI-CD)

## Setup Instructions

### 1. Configure CloudFlare R2 Backend

1. Copy the example backend configuration:
   ```bash
   cp backend.tf.example backend.tf
   ```

2. Edit `backend.tf` with your CloudFlare R2 details:
   ```hcl
   terraform {
     backend "s3" {
       bucket   = "my-terraform-state"
       key      = "terraform.tfstate"
       endpoint = "https://YOUR-ACCOUNT-ID.r2.cloudflarestorage.com"
       region   = "auto"
       
       skip_credentials_validation = true
       skip_metadata_api_check     = true
       skip_region_validation      = true
       skip_requesting_account_id  = true
       skip_s3_checksum            = true
       use_path_style              = true
     }
   }
   ```

3. Find your CloudFlare R2 Account ID:
   - Log in to CloudFlare Dashboard
   - Navigate to R2 → Overview
   - Your Account ID is displayed in the endpoint URL

### 2. Local Development Setup

For local development, use AWS CLI named profiles to separate credentials:

#### Step 1: Set up CloudFlare R2 credentials as environment variables

```bash
export AWS_ACCESS_KEY_ID="your-r2-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-r2-secret-access-key"
```

#### Step 2: Configure AWS CLI profile

Create or edit `~/.aws/credentials`:
```ini
[default]
aws_access_key_id = your-aws-access-key-id
aws_secret_access_key = your-aws-secret-access-key

[myproject]
aws_access_key_id = your-aws-access-key-id
aws_secret_access_key = your-aws-secret-access-key
```

Create or edit `~/.aws/config`:
```ini
[default]
region = us-east-1

[profile myproject]
region = us-east-1
```

#### Step 3: Use the module with AWS profile

```hcl
module "ec2_instance" {
  source = "path/to/terraform-aws-ec2-template"
  
  # Specify AWS profile for provider authentication
  aws_profile = "myproject"  # or "default"
  aws_region  = "us-east-1"
  
  # ... other variables ...
}
```

#### Step 4: Initialize and apply

```bash
# R2 credentials are read from environment variables for backend
# AWS credentials are read from the profile for provider
terraform init
terraform plan
terraform apply
```

### 3. GitHub Actions / CI-CD Setup

For GitHub Actions, use AWS OIDC authentication which doesn't rely on environment variables.

#### Step 1: Configure GitHub OIDC with AWS

Follow AWS documentation to set up OIDC:
https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services

#### Step 2: GitHub Actions workflow example

```yaml
name: Terraform Deploy

on:
  push:
    branches: [main]

permissions:
  id-token: write   # Required for OIDC
  contents: read

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      # Configure AWS credentials via OIDC
      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::123456789012:role/GitHubActionsRole
          aws-region: us-east-1
      
      # Set CloudFlare R2 credentials for backend
      - name: Configure R2 Backend Credentials
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.R2_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.R2_SECRET_ACCESS_KEY }}
        run: |
          # These env vars are used by terraform init for backend
          echo "R2 credentials configured"
      
      - name: Terraform Init
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.R2_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.R2_SECRET_ACCESS_KEY }}
        run: terraform init
      
      - name: Terraform Plan
        # AWS credentials from OIDC are used here (not env vars)
        run: terraform plan
      
      - name: Terraform Apply
        if: github.ref == 'refs/heads/main'
        run: terraform apply -auto-approve
```

**Important Notes:**
- `terraform init` needs R2 credentials via environment variables
- `terraform plan` and `terraform apply` use AWS OIDC credentials automatically
- Do NOT set `aws_profile` variable when using OIDC (leave it null/unset)

### 4. Alternative: Separate Environment Variables

If you prefer not to use AWS profiles, you can use separate environment variables:

```bash
# For Terraform backend (R2)
export AWS_ACCESS_KEY_ID="your-r2-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-r2-secret-access-key"

# For AWS provider (using TF_VAR prefix)
export TF_VAR_aws_access_key="your-aws-access-key-id"
export TF_VAR_aws_secret_key="your-aws-secret-access-key"
```

However, this approach requires modifying the module to accept these variables, so **using AWS profiles is the recommended approach** for local development.

## Verification

To verify your setup is working correctly:

```bash
# Initialize backend (uses R2 credentials from env vars)
terraform init

# Validate configuration (uses AWS credentials from profile or OIDC)
terraform validate

# Check which AWS account is being used
aws sts get-caller-identity --profile myproject
```

## Troubleshooting

### Error: "Invalid credentials" during terraform init
- Check that `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` contain your **R2** credentials
- Verify your R2 endpoint URL is correct

### Error: "Invalid credentials" during terraform plan/apply
- For local development: Check that your AWS profile is configured correctly
- For GitHub Actions: Verify OIDC role assumption is working

### Backend bucket not found
- Ensure the R2 bucket exists in CloudFlare
- Verify the endpoint URL matches your CloudFlare account ID

## Summary

| Component | Authentication Method | Credentials Source |
|-----------|----------------------|-------------------|
| **Terraform Backend (R2)** | Environment Variables | `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` |
| **AWS Provider (Local)** | AWS CLI Profile | `~/.aws/credentials`, `~/.aws/config` |
| **AWS Provider (CI/CD)** | OIDC/IAM Roles | GitHub Actions OIDC token |
