# Quick Start Guide: Using This Module with CloudFlare R2

This guide shows you the fastest way to get started with this module using CloudFlare R2 as your Terraform backend.

## Prerequisites

- CloudFlare account with R2 enabled
- AWS account with appropriate permissions
- Terraform >= 1.10.0
- AWS CLI configured (for local development)

## Quick Setup (Local Development)

### 1. Set up CloudFlare R2

1. Go to CloudFlare Dashboard → R2
2. Create a new R2 bucket for Terraform state (e.g., `my-terraform-state`)
3. Create API tokens:
   - Navigate to R2 → Manage R2 API Tokens
   - Create token with "Admin Read & Write" permissions
   - Save the `Access Key ID` and `Secret Access Key`

### 2. Configure Backend

```bash
# Copy the example backend configuration
cp backend.tf.example backend.tf

# Edit backend.tf with your details:
# - bucket: your-r2-bucket-name
# - endpoint: https://YOUR-ACCOUNT-ID.r2.cloudflarestorage.com
```

### 3. Set Environment Variables

```bash
# CloudFlare R2 credentials (for backend)
export AWS_ACCESS_KEY_ID="your-r2-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-r2-secret-access-key"
```

### 4. Configure AWS CLI Profile

```bash
# Configure AWS credentials
aws configure --profile myproject

# Or manually edit ~/.aws/credentials
cat >> ~/.aws/credentials << EOF
[myproject]
aws_access_key_id = your-aws-access-key-id
aws_secret_access_key = your-aws-secret-access-key
EOF
```

### 5. Use the Module

Create your `main.tf`:

```hcl
module "ec2_instance" {
  source = "github.com/jamieastley/terraform-aws-ec2-template"
  
  # AWS authentication
  aws_profile = "myproject"  # Uses credentials from ~/.aws/credentials
  aws_region  = "us-east-1"
  
  # Required variables
  app_name          = "my-app"
  app_description   = "My application"
  aws_ami           = "ami-0c55b159cbfafe1f0"
  aws_instance_type = "t2.micro"
  ec2_public_key    = file("~/.ssh/id_rsa.pub")
  
  instance_user_data = <<-EOF
    #!/bin/bash
    echo "Hello World"
  EOF
  
  s3_arn_allow_list = []
  
  ingress_rules = [{
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }]
  
  egress_rules = [{
    description      = "All traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }]
}
```

### 6. Deploy

```bash
# Initialize (uses R2 credentials from env vars)
terraform init

# Plan and apply (uses AWS credentials from profile)
terraform plan
terraform apply
```

## Quick Setup (GitHub Actions)

### 1. Configure AWS OIDC

Follow [GitHub's guide](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services) to set up OIDC.

### 2. Add GitHub Secrets

- `R2_ACCESS_KEY_ID`: Your CloudFlare R2 access key
- `R2_SECRET_ACCESS_KEY`: Your CloudFlare R2 secret key
- `AWS_ROLE_ARN`: Your AWS IAM role ARN for OIDC

### 3. Use Example Workflow

Copy `.github/workflows/terraform-r2-example.yml` and customize it for your needs.

**Key points:**
- Set R2 credentials as env vars ONLY for `terraform init`
- Don't set `aws_profile` variable (use default `null` for OIDC)
- AWS credentials come from OIDC automatically

## Troubleshooting

### "Invalid AWS credentials" during init
→ Check R2 credentials in environment variables

### "Invalid AWS credentials" during plan/apply
→ Check AWS profile configuration or OIDC setup

### "Backend bucket not found"
→ Verify R2 bucket exists and endpoint URL is correct

## More Information

See [R2_BACKEND.md](./R2_BACKEND.md) for comprehensive documentation.
