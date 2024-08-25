#!/bin/bash

# Define the parent directory
PARENT_DIR="/path/to/parent/directory"

# Find high-utilization directories at depth 1
echo "Finding high-utilization directories..."
HIGH_UTIL_DIRS=$(du -h --max-depth=1 "$PARENT_DIR" | sort -hr | awk '{print $2}')

# Loop through each high-utilization directory
for DIR in $HIGH_UTIL_DIRS; do
  echo "Listing top 25 files in $DIR..."
  find "$DIR" -maxdepth 1 -type f -exec du -h {} + | sort -rh | head -n 25
done
#
