#!/bin/bash

# Set the Jenkins workspace directory
WORKSPACE_DIR="/var/lib/jenkins/workspace"

# Check if the workspace directory exists
if [ ! -d "$WORKSPACE_DIR" ]; then
    echo "Error: Workspace directory $WORKSPACE_DIR does not exist."
    exit 1
fi

# Find directories older than 1 day
echo "Scanning for directories older than 1 day in $WORKSPACE_DIR..."
find "$WORKSPACE_DIR" -mindepth 1 -maxdepth 1 -type d -mtime +1 | while read -r dir; do
    echo "Processing directory: $dir"

    # Check if the directory is being accessed by any process
    if lsof +D "$dir" > /dev/null 2>&1; then
        echo "Skipping: $dir is in use."
    else
        # Delete the directory
        echo "Deleting: $dir"
        rm -rf "$dir"
        if [ $? -eq 0 ]; then
            echo "Successfully deleted: $dir"
        else
            echo "Failed to delete: $dir"
        fi
    fi
done

echo "Cleanup completed."
