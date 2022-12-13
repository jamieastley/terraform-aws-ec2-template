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