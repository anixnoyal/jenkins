#!/bin/bash

# Variables
JENKINS_HOME="/var/lib/jenkins"  # Path to Jenkins home (change if different)
JOBS_PATH="$JENKINS_HOME/jobs"   # Jenkins jobs folder
JENKINS_PROCESS=$(ps -ef | grep '[j]ava.*jenkins.war' | awk '{print $2}')  # Jenkins process PID

# Ensure Jenkins process PID is retrieved
if [ -z "$JENKINS_PROCESS" ]; then
    echo "Jenkins process not found. Is Jenkins running?"
    exit 1
fi

# Find tar and jar files under any archive folder in the jobs directory
find "$JOBS_PATH" -type f \( -name "*.tar" -o -name "*.jar" \) | while read -r file; do

    # Check if the file is open by the Jenkins process using lsof
    if lsof -p "$JENKINS_PROCESS" | grep -q "$file"; then
        echo "File is in use by Jenkins: $file"
    else
        # File not in use, remove it safely
        echo "Removing file: $file"
        rm -f "$file"
        if [ $? -eq 0 ]; then
            echo "Successfully removed: $file"
        else
            echo "Failed to remove: $file"
        fi
    fi
done
