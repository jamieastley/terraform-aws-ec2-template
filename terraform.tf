terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.74.0"
    }

    acme = {
      source  = "vancluever/acme"
      version = "~> 2.25.0"
    }
  }

  required_version = ">= 1.5.0"
}
