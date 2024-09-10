#!/bin/bash

# Variables
JENKINS_HOME="/var/lib/jenkins"  # Path to Jenkins home (change if different)
JOBS_PATH="$JENKINS_HOME/jobs"   # Jenkins jobs folder

# Find tar and jar files under any archive folder in the jobs directory
find "$JOBS_PATH" -type f \( -name "*.tar" -o -name "*.jar" \) | while read -r file; do

    # Check if the file is open by any process using lsof
    if lsof "$file" > /dev/null 2>&1; then
        echo "File is in use by a process, skipping: $file"
    else
        # File not in use, remove it safely
        echo "Removing file: $file"
        rm -v "$file"
        if [ $? -eq 0 ]; then
            echo "Successfully removed: $file"
        else
            echo "Failed to remove: $file"
        fi
    fi
done
#
