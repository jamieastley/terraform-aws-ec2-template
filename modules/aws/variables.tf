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
}

variable "ingress_rules" {
  description = "A list of ingress rules to apply to the provisioned instance"
  type        = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = optional(list(string))
  }))
}

variable "egress_rules" {
  description = "A list of egress rules to apply to the provisioned instance"
  type        = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = optional(list(string))
  }))
}

variable "instance_user_data" {
  description = "User data which will be passed to the provisioned instance"
  type = any
}

variable "enable_ssl_staging" {
  description = "Enable SSL staging for Lets Encrypt"
  type        = bool
  default     = true
}

variable "dns_email_address" {
  description = "Email address to use for SSL certificate"
  type        = string
}

variable "domain_name" {
  description = "Domain name to use for SSL certificate"
  type        = string
}

variable "subdomain_name" {
    description = "Subdomain name to use for SSL certificate"
    type        = string
}

variable "zone_id" {
  description = "The Zone ID which the created subdomain should point to"
  type = string
}
