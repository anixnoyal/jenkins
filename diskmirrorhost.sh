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

# Function to find the next available device
find_free_device() {
  for letter in {f..z}; do
    DEVICE="/dev/xvd$letter"
    if [ ! -e "$DEVICE" ]; then
      echo "$DEVICE"
      return
    fi
  done
  echo "No free device found" >&2
  exit 1
}

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

  if [ "$ATTACHED" != "None" ]; then
    echo "Detaching volume $VOLUME_ID from $ATTACHED"
    aws ec2 detach-volume --volume-id $VOLUME_ID --region $REGION
    aws ec2 wait volume-available --volume-ids $VOLUME_ID --region $REGION
    echo "Volume $VOLUME_ID detached."
  fi

  DEVICE=$(find_free_device)
  echo "Attaching volume $VOLUME_ID to $INSTANCE_ID on $DEVICE"
  aws ec2 attach-volume --volume-id $VOLUME_ID --instance-id $INSTANCE_ID --device $DEVICE --region $REGION
  aws ec2 wait volume-in-use --volume-ids $VOLUME_ID --region $REGION
  echo "Volume $VOLUME_ID successfully attached."

  # Get UUID
  UUID=$(blkid -s UUID -o value $DEVICE)

  # Update /etc/fstab if not already present
  grep -q "$UUID" /etc/fstab || echo "UUID=$UUID /mnt/jn-home-$ENV-bkp ext4 defaults,nofail 0 2" >> /etc/fstab

  # Create mount directory if it doesn't exist
  [ -d "/mnt/jn-home-$ENV-bkp" ] || mkdir -p /mnt/jn-home-$ENV-bkp

  # Reload system and mount
  systemctl daemon-reload
  mount -a

  echo "Volume $VOLUME_ID mounted at /mnt/jn-home-$ENV-bkp"
done
