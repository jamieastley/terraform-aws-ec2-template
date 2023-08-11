terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.12.0"
    }

    acme = {
      source  = "vancluever/acme"
      version = "~> 2.15.1"
    }
  }

  required_version = ">= 1.5.0"
}
