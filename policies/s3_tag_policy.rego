package s3_bucket

default allow = false

# Allow creation of the bucket only if the tags match the required value
allow {
    input.resource_changes[_].type == "aws_s3_bucket"
    input.resource_changes[_].change.after.tags["Environment"] == "DevOps"
}

# Allow operations that are not modifying tags
allow {
    input.operation != "PutBucketTagging"
}

# Allow modification of tags only if they match the required value
allow {
    input.operation == "PutBucketTagging"
    input.resource_changes[_].change.after.tags["Environment"] == "DevOps"
}

# Deny operations that try to modify tags when they don't match the required value
deny {
    input.operation == "PutBucketTagging"
    input.resource_changes[_].change.after.tags["Environment"] != "DevOps"
}

