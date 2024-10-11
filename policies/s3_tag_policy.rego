package terraform

<<<<<<< HEAD
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
=======
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
    all_tags = input.resource.tags
    # Ensure all required tags are present and have the correct values
    required_tags[key] == all_tags[key]  # This ensures each required key matches the tag value
    key = "Environment"                    # Key for required environment tag
    key = "Project"                        # Key for required project tag
>>>>>>> 32594fe (policy updated)
}

