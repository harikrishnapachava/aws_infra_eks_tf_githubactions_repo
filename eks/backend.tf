terraform {
  required_version = "~> 1.12.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.99.1"
    }
  }
  backend "s3" {
    bucket         = "hk-aws-infra-eks-tfstate-bucket"
    region         = "me-central-1"
    key            = "awsinfraeks/terraform.tfstate"
    use_lockfile = true
  }
}

provider "aws" {
  region  = var.aws-region
}
