provider "aws" {
    region = "ap-southeast-2"
}

resource "aws_s3_bucket" "terraform_state" {
    bucket = "terraform-state-esanders-devopsthehardway"
    versioning {
      enabled = true
    }
    server_side_encryption_configuration {
        rule {
          apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
          }
        }
    }
}
