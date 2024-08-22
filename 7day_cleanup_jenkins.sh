#!/bin/bash

# Process each directory one by one
echo "Starting cleanup in Jenkins directories..."

# Define directories to process
DIR1="/var/lib/jenkins/workspace"
DIR2="/var/lib/jenkins/cache"
DIR3="/var/lib/jenkins/tmp"

# Array of directories
DIRS=("$DIR1" "$DIR2" "$DIR3")

for DIR in "${DIRS[@]}"; do
    if [ -d "$DIR" ]; then
        echo "Processing directory: $DIR"
        
        # Remove files older than 7 days
        find "$DIR" -type f -mtime +7 -exec rm -f {} \;
        echo "Removed files older than 7 days in $DIR"
        
        # Remove empty directories
        find "$DIR" -type d -empty -delete
        echo "Removed empty directories in $DIR"
    else
        echo "Directory not found: $DIR"
    fi
done

echo "Jenkins cleanup completed!"
