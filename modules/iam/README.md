# IAM Terraform Module

This module manages AWS IAM resources required for the AWS Game Server infrastructure. It creates
IAM policies and roles with permissions necessary for provisioning and managing EC2, VPC, S3, and
SSM resources.

## Features

- Creates a custom IAM policy for Terraform to manage AWS resources
- Provisions an IAM role using the official terraform-aws-modules/iam/aws module
- Supports OIDC subjects for federated access
- Grants permissions for EC2, VPC, S3, and SSM operations

## Usage

```hcl
module "iam" {
  source = "../modules/iam"

  aws_region      = var.aws_region
  aws_account_id  = var.aws_account_id
  s3_bucket_name  = var.s3_bucket_name
  oidc_subjects = ["system:serviceaccount:default:example"]
  resource_prefix = "mygame"
}
```

## Input Variables

| Name            | Description                                | Type   | Default | Required |
|-----------------|--------------------------------------------|--------|---------|----------|
| aws_region      | AWS region                                 | string | n/a     | yes      |
| aws_account_id  | AWS account ID                             | string | n/a     | yes      |
| s3_bucket_name  | Name of the S3 bucket to grant access      | string | n/a     | yes      |
| oidc_subjects   | List of OIDC subjects for federated access | list   | []      | yes      |
| resource_prefix | Prefix for naming IAM resources            | string | n/a     | yes      |

## Outputs

- IAM role and policy ARNs for use in other modules or resources.

## Requirements

- Terraform >= 1.14
- AWS Provider >= 6.27
- terraform-aws-modules/iam/aws >= 6.2.3
- [prototools](https://github.com/theomessin/prototools) for managing Terraform versions and proto
  plugins

## Proto Setup

This module uses [proto](https://moonrepo.dev/proto) to manage Terraform
versions. To get started:

1. Install proto (see [proto installation guide](https://moonrepo.dev/docs/proto/install)).
2. Run the following command in the project root to install the required Terraform version and
   plugins:

   ```sh
   proto plugin add terraform "https://raw.githubusercontent.com/theomessin/proto-toml-plugins/master/terraform.toml"
   proto install terraform
   ```

3. Use `proto run terraform <command>` to run Terraform commands with the correct version, e.g.:
   ```sh
   proto run terraform init
   proto run terraform plan
   proto run terraform apply
   ```

## License

MIT
