terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.17.1"
    }
  }

  required_version = ">= 0.14.9"
}