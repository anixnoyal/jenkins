#!/bin/bash

MOUNT_BASE="/mnt"
FS_TYPE="xfs"

# Define volume mappings inside the script (volume-id:env:primary/backup)
VOLUME_INFO=(
    "vol-0abc12345678def01:DEV:primary"
    "vol-0def23456789abc02:STAGE:backup"
    "vol-0ghi34567890jkl03:PROD:primary"
    "vol-0mno45678901pqr04:DEV:backup"
)

# Loop through volume mappings
for ENTRY in "${VOLUME_INFO[@]}"; do
    VOLUME_ID=$(echo "$ENTRY" | cut -d: -f1)
    ENV_NAME=$(echo "$ENTRY" | cut -d: -f2)
    TYPE=$(echo "$ENTRY" | cut -d: -f3)

    # Ignore backup volumes
    if [[ "$TYPE" == "backup" ]]; then
        echo "Skipping backup volume: $VOLUME_ID"
        continue
    fi

    # Find device path from nvme list
    DEVICE_PATH=$(nvme list | grep "$VOLUME_ID" | awk '{print $1}')

    if [ -z "$DEVICE_PATH" ]; then
        echo "Volume $VOLUME_ID not found. Skipping..."
        continue
    fi

    echo "Processing $VOLUME_ID ($DEVICE_PATH) -> Mounting as $ENV_NAME-bkp"

    MOUNT_POINT="${MOUNT_BASE}/${ENV_NAME}-bkp"
    mkdir -p "$MOUNT_POINT"

    UUID=$(blkid -s UUID -o value "$DEVICE_PATH")
    echo "UUID=$UUID $MOUNT_POINT $FS_TYPE defaults,nofail 0 0" >> /etc/fstab

    mount "$MOUNT_POINT"
    echo "Mounted $DEVICE_PATH to $MOUNT_POINT"

done

echo "FSTAB setup completed!"
