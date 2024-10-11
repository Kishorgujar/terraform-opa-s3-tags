terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Adjust as needed
    }
  }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "bucket241011"
  tags = {
    Environment = "production-updated"  # Example of updated tag for testing
    Project     = "my_project"
  }
}
