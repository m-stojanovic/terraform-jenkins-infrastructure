terraform {
  backend "s3" {
    bucket         = "devops-terraform-states"
    key            = "ci/jenkins/k8s/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform_locks"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
  }
  required_version = ">= 0.13"
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "eu-west-1"
}

provider "cloudflare" {
  email      = "devops@devops.com"
  api_key    = ""
  account_id = ""
}