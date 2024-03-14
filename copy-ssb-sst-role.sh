#!/bin/bash

# Define variables
SOURCE_REGION="us-west-1"
DESTINATION_REGION="us-east-1"
VOLUME_ID="vol-0123456789abcdef0"  # Replace with your EBS volume ID
DESTINATION_KMS_KEY_ID="arn:aws:kms:us-east-1:123456789012:key/abcd1234-a123-456a-a12b-a123b4cd56ef"  # Replace with your destination KMS key ARN
ROLE_ARN="arn:aws:iam::123456789012:role/YourRoleName"  # Replace with the ARN of the role you want to assume
SESSION_NAME="CopySnapshotSession"
TAG_KEY="Key"   # Replace with your tag key
TAG_VALUE="Value"   # Replace with your tag value

# Assume the role and get temporary credentials
TEMP_CREDENTIALS=$(aws sts assume-role \
    --role-arn "$ROLE_ARN" \
    --role-session-name "$SESSION_NAME" \
    --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
    --output text)

# Parse temporary credentials
ACCESS_KEY_ID=$(echo $TEMP_CREDENTIALS | cut -d' ' -f1)
SECRET_ACCESS_KEY=$(echo $TEMP_CREDENTIALS | cut -d' ' -f2)
SESSION_TOKEN=$(echo $TEMP_CREDENTIALS | cut -d' ' -f3)

# Set temporary credentials as environment variables
export AWS_ACCESS_KEY_ID="$ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="$SECRET_ACCESS_KEY"
export AWS_SESSION_TOKEN="$SESSION_TOKEN"

# Check the identity of the caller
aws sts get-caller-identity

# Create a snapshot of the specified EBS volume
SNAPSHOT_ID=$(aws ec2 create-snapshot \
    --region "$SOURCE_REGION" \
    --volume-id "$VOLUME_ID" \
    --description "Snapshot of volume $VOLUME_ID" \
    --query 'SnapshotId' \
    --output text)

echo "Snapshot $SNAPSHOT_ID created for volume $VOLUME_ID"

# Copy the EBS snapshot from the source region to the destination region with encryption
COPIED_SNAPSHOT_ID=$(aws ec2 copy-snapshot \
    --region "$DESTINATION_REGION" \
    --source-region "$SOURCE_REGION" \
    --source-snapshot-id "$SNAPSHOT_ID" \
    --kms-key-id "$DESTINATION_KMS_KEY_ID" \
    --encrypted \
    --description "Encrypted copy of $SNAPSHOT_ID from $SOURCE_REGION to $DESTINATION_REGION" \
    --query 'SnapshotId' \
    --output text)

echo "Snapshot $SNAPSHOT_ID has been copied to $COPIED_SNAPSHOT_ID in $DESTINATION_REGION with encryption"

# Add tags to the copied snapshot in the destination region
aws ec2 create-tags \
    --region "$DESTINATION_REGION" \
    --resources "$COPIED_SNAPSHOT_ID" \
    --tags Key="$TAG_KEY",Value="$TAG_VALUE"

echo "Tagged $COPIED_SNAPSHOT_ID in $DESTINATION_REGION with $TAG_KEY=$TAG_VALUE"

# Clear temporary credentials from environment variables
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
