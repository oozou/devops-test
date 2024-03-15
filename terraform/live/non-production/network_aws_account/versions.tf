terraform {
  required_version = ">= 1.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }
  }

  backend "s3" {
    bucket         = "tfstate-non-production-abcdef"
    key            = "network"
    region         = "ap-southeast-1"
    encrypt        = true
    kms_key_id     = "alias/tfstate_bucket_kms_key"
    dynamodb_table = "tfstate_lock"
  }
}

provider "aws" {
  region = "ap-southeast-1"

  default_tags {
    tags = {
      Terraform   = true
      Environment = local.environment
    }
  }
}
