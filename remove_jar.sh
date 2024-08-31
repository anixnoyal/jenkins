#!/bin/bash

# Configuration
JENKINS_HOME="/var/lib/jenkins"           # Jenkins home directory
ARCHIVE_DIR="$JENKINS_HOME/jobs"           # Base directory containing job directories
TAR_FILE="/tmp/jar_files_$(date +%F_%T).tar.gz"  # Temporary tar file with timestamp
S3_BUCKET="s3://your-bucket-name"         # S3 bucket URL

# Step 1: Find JAR files under the 'archive' folders in Jenkins jobs directory and create a tar archive
find "$ARCHIVE_DIR" -type f -path '*/archive/*.jar' | tar -czf "$TAR_FILE" -T -

# Check if tar command was successful
if [ $? -ne 0 ]; then
  echo "Error creating tar file."
  exit 1
fi

# Step 2: Upload tar file to S3
aws s3 cp "$TAR_FILE" "$S3_BUCKET/"

# Check if upload was successful
if [ $? -ne 0 ]; then
  echo "Error uploading tar file to S3."
  exit 1
fi

# Step 3: Remove the local tar file
rm "$TAR_FILE"

# Check if removal was successful
if [ $? -ne 0 ]; then
  echo "Error removing local tar file."
  exit 1
fi

# Step 4: Remove JAR files from the 'archive' folders in Jenkins jobs directory
find "$ARCHIVE_DIR" -type f -path '*/archive/*.jar' -exec rm {} +

# Check if removal was successful
if [ $? -ne 0 ]; then
  echo "Error removing JAR files."
  exit 1
fi

echo "Process completed successfully."
