provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "bucket241011"
  tags = {
   Environment = "production-updated"  # Change this tag to test policy
    Project     = "my_project"
  }
