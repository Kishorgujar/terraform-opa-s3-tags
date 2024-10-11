package terraform

deny {
    input.resource_changes[_].type == "aws_s3_bucket"
    input.resource_changes[_].change.actions[_] == "update"
    input.resource_changes[_].change.after.tags["Environment"] != input.resource_changes[_].change.before.tags["Environment"]
}

deny {
    input.resource_changes[_].type == "aws_s3_bucket"
    input.resource_changes[_].change.actions[_] == "update"
    input.resource_changes[_].change.after.tags["Project"] != input.resource_changes[_].change.before.tags["Project"]
}

