terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket         = "magento-terraform-state-bucket"
    key            = "magento/terraform.tfstate"   # path inside bucket to store state
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"              # table for locking
    encrypt        = true
  }
}

