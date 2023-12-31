terraform {
  required_version = "> 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.3.0"
    }
  }

  backend "s3" {
    region  = "us-west-2"
    bucket  = "awsnetblog-s3b-tf"
    key     = "state"
    profile = "default"
  }
}

provider "aws" {
  region                   = var.region
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
}

