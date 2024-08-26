#!/bin/bash

# Set the directory where Jenkins stores its jobs
JENKINS_HOME="/var/lib/jenkins"
ARCHIVE_DIRS=$(find "$JENKINS_HOME/jobs" -type d -name "archive")

# Set the threshold size (100MB)
THRESHOLD=100

for dir in $ARCHIVE_DIRS; do
    # Calculate the size of the archive directory in MB
    DIR_SIZE=$(du -sm "$dir" | cut -f1)
    
    # Check if the directory size exceeds the threshold
    if [ "$DIR_SIZE" -gt "$THRESHOLD" ]; then
        echo "Deleting archive in: $dir (Size: ${DIR_SIZE}MB)"
        rm -rf "$dir"
    fi
done
