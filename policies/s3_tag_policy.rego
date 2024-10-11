package s3_bucket

default allow = false

# Allow operation if it's not modifying tags
allow {
    input.operation != "PutBucketTagging"
}

# Allow operation if trying to modify tags and they match the required values
allow {
    input.operation == "PutBucketTagging"
    input.tags["Environment"] == "DevOps"
}

# Deny operation if trying to modify tags and they do not match the required values
deny {
    input.operation == "PutBucketTagging"
    input.tags["Environment"] != "DevOps"
}
