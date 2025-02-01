#!/bin/bash

CONFIG_FILE="config.txt"
MOUNT_BASE="/mnt"

# Ensure config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file not found!"
    exit 1
fi

# Read config file into an array
mapfile -t CONFIG_LINES < "$CONFIG_FILE"

# Loop through each line in config file
for LINE in "${CONFIG_LINES[@]}"; do
    VOLUME_ID=$(echo "$LINE" | cut -d: -f1)
    ENV_NAME=$(echo "$LINE" | cut -d: -f2)

    DEVICE_PATH=$(nvme list | grep "$VOLUME_ID" | awk '{print $1}')

    if [ -z "$DEVICE_PATH" ]; then
        echo "Volume $VOLUME_ID not found. Skipping..."
        continue
    fi

    echo "Processing $VOLUME_ID -> $DEVICE_PATH"

    MOUNT_POINT="${MOUNT_BASE}/${ENV_NAME}-bkp"
    mkdir -p "$MOUNT_POINT"

    UUID=$(blkid -s UUID -o value "$DEVICE_PATH")
    echo "UUID=$UUID $MOUNT_POINT ext4 defaults,nofail 0 2" >> /etc/fstab

    mount "$MOUNT_POINT"
    echo "Mounted $DEVICE_PATH to $MOUNT_POINT"

done

echo "FSTAB setup completed!"





#!/bin/bash

MOUNT_BASE="/mnt"

# Define volume mappings inside the script (volume-id:envname)
VOLUME_INFO=(
    "vol-0abc12345678def01:DEV"
    "vol-0def23456789abc02:STAGE"
    "vol-0ghi34567890jkl03:PROD"
    "vol-0mno45678901pqr04:DEV"
)

# Loop through volume mappings
for ENTRY in "${VOLUME_INFO[@]}"; do
    VOLUME_ID=$(echo "$ENTRY" | cut -d: -f1)
    ENV_NAME=$(echo "$ENTRY" | cut -d: -f2)

    # Ignore PROD volumes
    if [[ "$ENV_NAME" == "PROD" ]]; then
        echo "Skipping PROD volume: $VOLUME_ID"
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
    echo "UUID=$UUID $MOUNT_POINT ext4 defaults,nofail 0 2" >> /etc/fstab

    mount "$MOUNT_POINT"
    echo "Mounted $DEVICE_PATH to $MOUNT_POINT"

done

echo "FSTAB setup completed!"
