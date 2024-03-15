locals {
  region = "ap-southeast-1"
}
terraform {
  required_version = ">= 1.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.20.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }
  }

  backend "s3" {
    bucket         = "tfstate-production-rfvtgb"
    key            = "workload"
    region         = "ap-southeast-1"
    encrypt        = true
    kms_key_id     = "alias/tfstate_bucket_kms_key"
    dynamodb_table = "tfstate_lock"
  }
}

provider "aws" {
  region = local.region

  default_tags {
    tags = {
      Terraform   = true
      Environment = local.environment
    }
  }
}

provider "kubernetes" {
}
