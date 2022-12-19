variable "aws_instance_type" {
  description = "The EC2 instance type which will be provisioned"
  type        = string
  nullable    = false
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

#variable "vpc_name" {
#  description = "The name of the VPC"
#  type = string
#}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "zone_id" {
  description = "The Zone ID which the created subdomain should point to"
  type = string
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
}

variable "dns_email_address" {
  description = "The email address which will be used for requesting certificates from LetsEncrypt"
  type = string
}

variable "enable_letsencrypt_staging" {
  description = "Sets whether the LetsEncrypt staging server should be used."
  type = bool
  default = true
}

variable "domain_name" {
  description = "The domain name to create the subdomain against"
  type = string
}

variable "subdomain_name" {
  description = "The subdomain on which the example will be deployed to"
  type = string
  default = "hello"
}

variable "log_secure_values" {
  description = "Enables or disables the output of secure values"
  type = bool
  default = false
}