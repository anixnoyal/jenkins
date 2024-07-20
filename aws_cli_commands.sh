List EC2 Instances with a Specific Tag Name:

aws ec2 describe-instances --filters "Name=tag-key,Values=YOUR_TAG_NAME" --query "Reservations[*].Instances[*].[InstanceId,Tags]" --output table
