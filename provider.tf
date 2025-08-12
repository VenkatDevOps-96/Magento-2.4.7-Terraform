provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "magento-terraform-state-bucket"
    key            = "env/dev/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
  }
}

