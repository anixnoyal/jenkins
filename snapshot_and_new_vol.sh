#!/bin/bash

# Variables
VOLUME_ID="vol-xxxxxxxx"  # Replace with the EBS volume ID to snapshot
SNAPSHOT_DESCRIPTION="Snapshot of volume $VOLUME_ID"
REGION="us-west-2"
SOURCE_AZ="us-west-2b"  # The AZ where the original volume resides
TARGET_AZ="us-west-2a"  # The AZ where the new volume will be created

# Tags
TAG_NAME="MyEBSVolume"
TAG_EMAIL="user@example.com"
TAG_LOCATION="US"
TAG_ENV="Production"

# Step 1: Create an EBS Snapshot from the volume in AZ2 (us-west-2b) with tags
echo "Creating a snapshot of volume $VOLUME_ID in $SOURCE_AZ with tags..."
SNAPSHOT_ID=$(aws ec2 create-snapshot \
    --volume-id $VOLUME_ID \
    --description "$SNAPSHOT_DESCRIPTION" \
    --region $REGION \
    --tag-specifications "ResourceType=snapshot,Tags=[{Key=Name,Value=$TAG_NAME},{Key=Email,Value=$TAG_EMAIL},{Key=Location,Value=$TAG_LOCATION},{Key=Env,Value=$TAG_ENV}]" \
    --query 'SnapshotId' --output text)

if [ -z "$SNAPSHOT_ID" ]; then
    echo "Failed to create snapshot."
    exit 1
fi

echo "Snapshot created with ID: $SNAPSHOT_ID"

# Step 2: Wait for the snapshot to complete
echo "Waiting for the snapshot to be completed..."
aws ec2 wait snapshot-completed --snapshot-ids $SNAPSHOT_ID --region $REGION

if [ $? -ne 0 ]; then
    echo "Snapshot creation failed or took too long."
    exit 1
fi

echo "Snapshot $SNAPSHOT_ID is completed."

# Step 3: Create a new EBS Volume in AZ1 (us-west-2a) from the snapshot with tags
echo "Creating a new volume in $TARGET_AZ from snapshot $SNAPSHOT_ID with tags..."
NEW_VOLUME_ID=$(aws ec2 create-volume \
    --snapshot-id $SNAPSHOT_ID \
    --availability-zone $TARGET_AZ \
    --region $REGION \
    --tag-specifications "ResourceType=volume,Tags=[{Key=Name,Value=$TAG_NAME},{Key=Email,Value=$TAG_EMAIL},{Key=Location,Value=$TAG_LOCATION},{Key=Env,Value=$TAG_ENV}]" \
    --query 'VolumeId' --output text)

if [ -z "$NEW_VOLUME_ID" ]; then
    echo "Failed to create a new volume from the snapshot."
    exit 1
fi

echo "New volume created with ID: $NEW_VOLUME_ID in $TARGET_AZ"

# Step 4: Wait for the new volume to be available
echo "Waiting for the new volume to become available..."
aws ec2 wait volume-available --volume-ids $NEW_VOLUME_ID --region $REGION

if [ $? -ne 0 ]; then
    echo "Volume creation failed or took too long."
    exit 1
fi

echo "Volume $NEW_VOLUME_ID is now available."

# Final Output
echo "Snapshot ID: $SNAPSHOT_ID"
echo "New Volume ID: $NEW_VOLUME_ID in $TARGET_AZ"
