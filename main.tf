resource "aws_s3_bucket" "my_bucket" {
  bucket = "bucket241011"
  tags = {
    Environment = "production-updated"  # Example of updated tag for testing
    Project     = "my_project"
  }
}
