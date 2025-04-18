terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.80"
    }
  }

}

provider "aws" {
  default_tags {
    tags = local.tags
  }
}

resource "aws_iam_policy" "tf_policy" {
  name        = "${local.resource_prefix}-tf-policy"
  description = "Allows Terraform to interact with the required AWS resources to create the game server"
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:AssociateAddress",
          "ec2:CreateTags",
          "ec2:DeleteKeyPair",
          "ec2:DescribeAddresses",
          "ec2:DescribeAddressesAttribute",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeImages",
          "ec2:DescribeInstanceCreditSpecifications",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstances",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeKeyPairs",
          "ec2:DescribeNetworkAcls",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DescribeVpcs",
          "ec2:DisassociateAddress",
          "ec2:DisassociateRouteTable",
          "ec2:ReleaseAddress",
          "sts:GetCallerIdentity"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "ec2:AllocateAddress",
        "Resource" : "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:elastic-ip/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeInstanceAttribute",
          "ec2:ModifyInstanceAttribute",
          "ec2:RunInstances",
          "ec2:TerminateInstances"
        ],
        "Resource" : "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:instance/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:AttachInternetGateway",
          "ec2:CreateInternetGateway",
          "ec2:DeleteInternetGateway",
          "ec2:DetachInternetGateway"
        ],
        "Resource" : "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:internet-gateway/*"
      },
      {
        "Effect" : "Allow",
        "Action" : "ec2:ImportKeyPair",
        "Resource" : "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:key-pair/*"
      },
      {
        "Effect" : "Allow",
        "Action" : "ec2:RunInstances",
        "Resource" : "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:network-interface/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:AssociateRouteTable",
          "ec2:CreateRoute",
          "ec2:CreateRouteTable",
          "ec2:DeleteRouteTable"
        ],
        "Resource" : "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:route-table/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:RunInstances"
        ],
        "Resource" : "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:security-group/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:CreateSubnet",
          "ec2:DeleteSubnet",
          "ec2:ModifySubnetAttribute",
          "ec2:RunInstances"
        ],
        "Resource" : "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:subnet/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:AttachInternetGateway",
          "ec2:CreateRouteTable",
          "ec2:CreateSubnet",
          "ec2:CreateVpc",
          "ec2:DeleteVpc",
          "ec2:DescribeVpcAttribute",
          "ec2:DetachInternetGateway"
        ],
        "Resource" : "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:vpc/*"
      },
      {
        "Effect" : "Allow",
        "Action" : "ec2:RunInstances",
        "Resource" : "arn:aws:ec2:${var.aws_region}::image/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:GetAccelerateConfiguration",
          "s3:GetBucketAcl",
          "s3:GetBucketCORS",
          "s3:GetBucketLogging",
          "s3:GetBucketObjectLockConfiguration",
          "s3:GetBucketPolicy",
          "s3:GetBucketRequestPayment",
          "s3:GetBucketTagging",
          "s3:GetBucketVersioning",
          "s3:GetBucketWebsite",
          "s3:GetEncryptionConfiguration",
          "s3:GetLifecycleConfiguration",
          "s3:GetReplicationConfiguration"
        ],
        "Resource" : "arn:aws:s3:::${var.s3_bucket_name}"
      },
      {
        "Effect" : "Allow",
        "Action" : "ssm:GetParameters",
        "Resource" : "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:parameter/*"
      }
    ]
  })
}

