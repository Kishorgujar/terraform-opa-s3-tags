terraform {
  backend "s3" {
    bucket         = "bucket241011"  # Replace with your actual S3 bucket name
    key            = "terraform.tfstate"
    region         = "ap-south-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Adjust as needed
    }
  }
}

provider "aws" {
  region = "ap-south-1"  # Specify the region for AWS provider
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "Mainbucket241011"
  
  tags = {
    Environment = "Testing"  # Example of a tag for testing
    Project     = "automation"
  }
}
