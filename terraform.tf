terraform {
  required_version = ">=1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.10.0"
    }
  }
}

provider "aws" {
  region  = "us-west-2"
  profile = "block"
  default_tags {
    tags = {
      "Product"     = "ipfs"
      "Terraform"   = "true"
      "Environment" = "dev"
    }
  }
}
