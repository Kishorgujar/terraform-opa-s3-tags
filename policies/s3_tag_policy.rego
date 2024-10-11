package terraform

# Default rule: allow all changes unless denied
default allow = true

# Define the required tags and their expected values
required_tags = {
    "Environment": "Testing",
    "Project":     "Automation"
}

# Deny rule for S3 bucket tag modifications
deny {
    input.resource_type == "aws_s3_bucket"  # Check if the resource is an S3 bucket
    input.change["tags"] != input.original["tags"]  # Compare new tags with original tags
}

# Deny rule for missing required tags
deny[{"msg": msg}] {
    input.resource_type == "aws_s3_bucket"  # Ensure we're checking an S3 bucket
    not required_tags_match                   # Check if the required tags match
    msg = sprintf("S3 bucket must have tags: %v.", [required_tags])  # Construct a violation message
}

# Check if the tags in the input match the required tags
required_tags_match {
    all_tags = input.resource_changes[_].change.after.tags  # Access the tags of the resource
    all(key) = { "Environment", "Project" }  # Define the required keys to check
    required_tags[key] == all_tags[key]  # Ensure each required key matches the tag value
}
