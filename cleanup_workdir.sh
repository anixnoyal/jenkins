#!/bin/bash

# Set the Jenkins workspace folder
WORKSPACE_DIR="/var/lib/jenkins/workspace"

# Check if the workspace directory exists
if [[ ! -d "$WORKSPACE_DIR" ]]; then
    echo "Error: Workspace directory $WORKSPACE_DIR does not exist."
    exit 1
fi

# Log file for cleanup process
LOG_FILE="/var/log/jenkins_workspace_cleanup.log"
echo "Cleanup started at $(date)" > "$LOG_FILE"

# Find directories in the workspace older than 1 day
find "$WORKSPACE_DIR" -mindepth 1 -maxdepth 1 -type d -mtime +1 | while read -r dir; do
    # Check if there are any open files in the directory
    if lsof +D "$dir" > /dev/null 2>&1; then
        echo "Skipping $dir: Open files detected." | tee -a "$LOG_FILE"
    else
        # Remove the directory
        echo "Removing $dir..." | tee -a "$LOG_FILE"
        rm -rf "$dir" && echo "$dir removed successfully." | tee -a "$LOG_FILE"
    fi
done

echo "Cleanup finished at $(date)" >> "$LOG_FILE"
