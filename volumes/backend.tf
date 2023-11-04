terraform {

  required_version = "> 1.0.7"

  backend "s3" {
    bucket         = "devops-terraform-states"
    key            = "ci/jenkins/volumes-prod/ci.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform_locks"
  }

  required_providers {
    aws = {
      version = "~> 3.56.0"
    }
    helm = {
      version = "~> 2.3.0"
    }
  }

}

provider "aws" {
  region = "eu-west-1"
}