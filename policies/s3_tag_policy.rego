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
    input.resource_type == "aws_s3_bucket"  # Check if the resource is an S3 bucketpackage terraform

# Default rule: allow all changes unless denied
default allow = true

# Deny rule for S3 bucket tag modifications
deny {
    input.resource_type == "aws_s3_bucket"  # Check if the resource is an S3 bucket
    input.change["tags"] != input.original["tags"]  # Compare new tags with original tags
}

# Allow rule for specific S3 bucket tag values
allow {
    some r  # Iterate over resource changes
    input.resource_changes[r].address == "aws_s3_bucket.my_bucket"  # Match the bucket address
    input.resource_changes[r].change.after.tags["Environment"] == "production-updated"  # Tag must match
    input.resource_changes[r].change.after.tags["Project"] == "my_project"  # Tag must match
}

# Define the rule for denying changes based on tag conditions
deny[{"msg": msg}] {
    input.resource_type == "aws_s3_bucket"  # Ensure we're checking an S3 bucket
    not required_tags_match                   # Check if the required tags match
    msg = sprintf("S3 bucket must have tags: %v.", [required_tags])  # Construct a violation message
}

# Define the required tags and their expected values
required_tags = {
    "Environment": "Testing",
    "Project":     "Automation"
}

# Check if the tags in the input match the required tags
required_tags_match {
    all_tags = input.resource_changes[_].change.after.tags  # Access the tags of the resource
    required_tags[key] == all_tags[key]  # Ensure each required key matches the tag value
    key = "Environment"                    # Check required environment tag
}

required_tags_match {
    all_tags = input.resource_changes[_].change.after.tags  # Access the tags of the resource
    required_tags[key] == all_tags[key]  # Ensure each required key matches the tag value
    key = "Project"                        # Check required project tag
}
    input.change["tags"] != input.original["tags"]  # Compare new tags with original tags
}

# Allow rule for specific S3 bucket tag values
allow {
    some r  # Iterate over resource changes
    input.resource_changes[r].address == "aws_s3_bucket.my_bucket"  # Match the bucket address
    input.resource_changes[r].change.after.tags["Environment"] == "production-updated"  # Tag must match
    input.resource_changes[r].change.after.tags["Project"] == "my_project"  # Tag must match
}

# Define the rule for denying changes based on required tag conditions
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
