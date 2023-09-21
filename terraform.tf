terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.9.0"
    }

    acme = {
      source  = "vancluever/acme"
      version = "~> 2.17.2"
    }
  }

  required_version = ">= 1.5.0"
}
