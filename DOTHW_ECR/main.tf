terraform {
  backend "s3" {
    bucket = "terraform-state-esanders-devopsthehardway"
    key = "ecr-terraform.tfstate"
    region = "ap-southeast-2"
  }
  required_providers {
    aws = {
        source = "hashicorp/aws"
    }
  }
}

provider "aws" {
    region = "ap-southeast-2"
}

resource "aws_ecr_repository" "esanders-devopsthehardway-ecr-repo" {
    name = var.repo_name
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
      scan_on_push = true
    }
}