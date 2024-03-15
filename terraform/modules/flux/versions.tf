terraform {
  required_version = ">= 1.4"

  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = "1.2.2" # Flux v2
      # version = "0.25.3"
    }
    github = {
      source  = "integrations/github"
      version = ">= 5.18.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5"
    }
  }
}
