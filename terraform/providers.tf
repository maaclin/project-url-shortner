
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.9.0"
    }
  }

  backend "s3" {
    bucket       = "project-ecsv2"
    key          = "terraform"
    region       = "eu-west-2"
    use_lockfile = true
    encrypt      = true

  }
}

provider "aws" {
  region = "eu-west-2"
}