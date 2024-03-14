#!/bin/bash

# Define variables
SOURCE_REGION="us-west-1"
DESTINATION_REGION="us-east-1"
VOLUME_ID="vol-0123456789abcdef0"  # Replace with your EBS volume ID
DESTINATION_KMS_KEY_ID="arn:aws:kms:us-east-1:123456789012:key/abcd1234-a123-456a-a12b-a123b4cd56ef"  # Replace with your destination KMS key ARN
TAG_KEY="Key"   # Replace with your tag key
TAG_VALUE="Value"   # Replace with your tag value

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
