provider "aws" {
  region  = var.region
  profile = var.profile

  default_tags {
   tags = {
     Environment = "dev"
     Product     = "Automation-station"
	 GithubURL   = "https://github.com/tarmac/automation-station-tf"
   }
 }
}

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket         = "s3-785700991304-terraform-state-dev"
    dynamodb_table = "dynamo-785700991304-terraform-locks-dev"
    encrypt        = "true"
    key            = "infra-dev.tfstate"
    profile        = "automation"
    region         = "us-east-1"
  }
}
