package terraform

# Default deny rule
default allow = false
default deny = false

# Deny rule for S3 bucket tag modifications
deny {
    input.resource_type == "aws_s3_bucket"  # Check if the resource is an S3 bucket
    input.change["tags"] != input.original["tags"]  # Compare new tags with original tags
}

# Allow rule for S3 bucket creation with specific tags
allow {
    some r  # For each resource in resource_changes
    input.resource_changes[r].address == "aws_s3_bucket.my_bucket"  # Check if it's the specific bucket
    input.resource_changes[r].change.after.tags["Environment"] == "Testing"  # Required tag
    input.resource_changes[r].change.after.tags["Project"] == "automation"  # Required tag
}

# Allow rule for modifying existing S3 bucket tags to a specific state
allow {
    input.resource_type == "aws_s3_bucket"  # Check if the resource is an S3 bucket
    input.change["tags"]["Environment"] == "production-updated"  # Required tag for modification
    input.change["tags"]["Project"] == "my_project"  # Required tag for modification
}
