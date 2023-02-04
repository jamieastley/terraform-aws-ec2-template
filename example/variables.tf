# Terraform
variable "terraform_org" {
  description = "The name of the Terraform Cloud organization"
  type        = string
  sensitive   = true
}

variable "terraform_workspace" {
  description = "The name of the Terraform Cloud workspace"
  type        = string
  sensitive   = true
}

# EC2
variable "aws_instance_type" {
  description = "The EC2 instance type which will be provisioned"
  type        = string
  nullable    = false
  default     = "t3a.medium"
}

variable "aws_region" {
  description = "The region in which the EC2 instance will be provisioned"
  type        = string
  nullable    = false
}

variable "aws_ami" {
  description = "The AMI to use for the EC2 instance"
  type        = string
  nullable    = false
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_enable_nat_gateway" {
  description = "Enable NAT gateway for VPC"
  type        = bool
  default     = true
}

variable "app_name" {
  description = "The name of the app service that's being deployed. Name will be concatenated into resource names"
  type        = string
  nullable    = false
}

variable "ssh_key_name" {
  description = "The name of the SSH key that will be used to access the provisioned instance"
  type        = string
  sensitive   = true
}

variable "dns_email_address" {
  description = "The email address which will be used for requesting certificates from LetsEncrypt"
  type        = string
  sensitive   = true
}

variable "enable_letsencrypt_staging" {
  description = "Sets whether the LetsEncrypt staging server should be used."
  type        = bool
  default     = true
}

variable "hosted_zone_name" {
  description = "The name of the existing hosted zone which the subdomain will be created in"
  type        = string
}

variable "subdomain_name" {
  description = "The subdomain on which the example will be deployed to"
  type        = string
  default     = "example"
}

variable "log_secure_values" {
  description = "Enables or disables the output of secure values"
  type        = bool
  default     = false
}

variable "enable_ssl_staging" {
  description = "Enable SSL staging for Lets Encrypt"
  type        = bool
  default     = true
}

variable "ec2_username" {
  description = "The user of the EC2 instance"
  type        = string
  sensitive   = true
}

# S3
variable "docker_image" {
  description = "The Docker image to use for the Valheim server"
  type        = string
  default     = "mbround18/valheim:latest"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket to use for game data backups"
  type        = string
}

variable "valheim_world_name" {
  description = "The name of the Valheim world to use"
  type        = string
}

variable "valheim_server_password" {
  description = "The password for the Valheim server"
  type        = string
  sensitive   = true
}

variable "valheim_server_timezone" {
  description = "The timezone for the Valheim server"
  type        = string
  default     = "Australia/Sydney"
}

variable "valheim_hugin_webhook_url" {
  description = "The webhook URL for Hugin"
  type        = string
  sensitive   = true
}

variable "valheim_server_type" {
  description = "The type of Valheim server to create. "
  type        = string
  default     = "ValheimPlus"
  validation {
    condition     = contains(["ValheimPlus", "BepInEx", "BepInExFull", "Vanilla"], var.valheim_server_type)
    error_message = "The valheim_server_type variable must be either ValheimPlus, BepInEx, BepInExFull, or Vanilla."
  }
}