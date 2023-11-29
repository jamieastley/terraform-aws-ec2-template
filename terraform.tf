terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.28.0"
    }

    acme = {
      source  = "vancluever/acme"
      version = "~> 2.18.0"
    }
  }

  required_version = ">= 1.5.0"
}
