terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.48.0"
    }

    acme = {
      source  = "vancluever/acme"
      version = "~> 2.21.0"
    }
  }

  required_version = ">= 1.5.0"
}
