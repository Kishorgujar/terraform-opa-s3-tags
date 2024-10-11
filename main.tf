terraform {
  backend "s3" {
    bucket         = "statebuc241011"  # Replace with your actual S3 bucket name
    key            = "terraform.tfstate"
    region         = "ap-south-1"
  }
}
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
    Environment = "Testing"  # Example of updated tag for testing
    Project     = "automation"
  }
}
