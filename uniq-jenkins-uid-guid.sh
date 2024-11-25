#!/bin/bash

# Target UID and GID
TARGET_UID=807
TARGET_GID=796

# Current UID and GID of the jenkins user
CURRENT_UID=$(id -u jenkins 2>/dev/null)
CURRENT_GID=$(id -g jenkins 2>/dev/null)

# Function to update ownership of files and directories
update_permissions() {
    local old_id=$1
    local new_id=$2
    local type=$3 # 'user' or 'group'

    echo "Updating ownership of files and directories for $type ID $old_id to $new_id..."
    if [ "$type" == "user" ]; then
        find / -uid "$old_id" -exec chown -h "$new_id" {} \; 2>/dev/null
    elif [ "$type" == "group" ]; then
        find / -gid "$old_id" -exec chgrp -h "$new_id" {} \; 2>/dev/null
    fi
}

# Check and update GID
if [ "$CURRENT_GID" != "$TARGET_GID" ]; then
    echo "Changing GID of jenkins from $CURRENT_GID to $TARGET_GID..."
    sudo groupmod -g "$TARGET_GID" jenkins
    update_permissions "$CURRENT_GID" "$TARGET_GID" "group"
else
    echo "Jenkins group already has the target GID: $TARGET_GID"
fi

# Check and update UID
if [ "$CURRENT_UID" != "$TARGET_UID" ]; then
    echo "Changing UID of jenkins from $CURRENT_UID to $TARGET_UID..."
    sudo usermod -u "$TARGET_UID" jenkins
    update_permissions "$CURRENT_UID" "$TARGET_UID" "user"
else
    echo "Jenkins user already has the target UID: $TARGET_UID"
fi

echo "All changes completed successfully."
