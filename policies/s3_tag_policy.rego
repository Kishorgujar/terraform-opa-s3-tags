package terraform

default allow = false
default deny = false

# Example original tags; adjust to match your actual configuration
original_tags = {
    "Environment": "AWS",
    "Project": "CICD"
}

# Deny rule for S3 bucket tag modifications
deny {
    input.resource_type == "aws_s3_bucket"  # Check if the resource is an S3 bucket
    input.change["tags"] != original_tags  # Compare new tags with original tags
}

# Allow rule for S3 bucket creation
allow {
    some r  # Iterate over resource changes
    input.resource_changes[r].address == "aws_s3_bucket.my_bucket"  # Match the bucket address
    input.resource_changes[r].change.after.tags["Environment"] == "production-updated"  # Tag must match
    input.resource_changes[r].change.after.tags["Project"] == "my_project"  # Tag must match
}
