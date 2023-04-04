terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket         = "s3-785700991304-terraform-state-dev"
    key            = "terraform.tfstate"
    profile        = "automation-station"
    region         = "us-east-1"
    dynamodb_table = "dynamo-785700991304-terraform-locks-dev"
    encrypt        = true
  }
  required_version = ">= 1.1.5"
}

provider "aws" {
  profile = var.profile
  region  = var.region
}