terraform {
  required_version = ">= 1.4"

  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
