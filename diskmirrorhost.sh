#!/bin/bash

# Define volume mapping inline
declare -A VOLUMES=(
  [prod1]=vol-aaaaaaaaaaaaaaa:us-west-2
  [prod2]=vol-bbbbbbbbbbbbbbb:us-east-1
  [prod3]=vol-ccccccccccccccc:us-west-1
  [prod4]=vol-ddddddddddddddd:us-east-2
  [prod5]=vol-eeeeeeeeeeeeeee:us-west-2
  # Add up to prod50 following the same format
)

# Get instance ID and region
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/region)

# Loop through all volumes
for ENV in "${!VOLUMES[@]}"; do
  VOLUME_ID=$(echo ${VOLUMES[$ENV]} | cut -d':' -f1)
  VOLUME_REGION=$(echo ${VOLUMES[$ENV]} | cut -d':' -f2)

  # Skip volumes not in the current region
  if [ "$VOLUME_REGION" != "$REGION" ]; then
    continue
  fi

  # Check if volume is attached
  ATTACHED=$(aws ec2 describe-volumes --volume-ids $VOLUME_ID --region $REGION --query "Volumes[0].Attachments[*].InstanceId" --output text)

  if [ "$ATTACHED" == "None" ]; then
    echo "Attaching volume $VOLUME_ID to $INSTANCE_ID"
    aws ec2 attach-volume --volume-id $VOLUME_ID --instance-id $INSTANCE_ID --device /dev/xvdf --region $REGION
    sleep 10 # Wait for attachment
  else
    echo "Volume $VOLUME_ID already attached to $ATTACHED"
  fi

  # Get UUID
  UUID=$(blkid -s UUID -o value /dev/xvdf)

  # Update /etc/fstab if not already present
  grep -q "$UUID" /etc/fstab || echo "UUID=$UUID /mnt/$ENV ext4 defaults,nofail 0 2" >> /etc/fstab

  # Create mount directory if it doesn't exist
  [ -d "/mnt/$ENV" ] || mkdir -p /mnt/$ENV

  # Reload system and mount
  systemctl daemon-reload
  mount -a

  echo "Volume $VOLUME_ID mounted at /mnt/$ENV"
done
