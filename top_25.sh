#!/bin/bash

# Define the base directory of your Jenkins workspace (change as needed)
BASE_DIR="/var/lib/jenkins"

# Resolve the real path if BASE_DIR is a symbolic link
REAL_DIR=$(readlink -f "$BASE_DIR")

# Step 1: Find the top 25 largest directories and save the paths to a file
OUTPUT_FILE="top_25_dirs.txt"
echo "Finding top 25 largest directories in $REAL_DIR..."
du -ah --max-depth=1 "$REAL_DIR" 2>/dev/null | sort -rh | head -n 25 > "$OUTPUT_FILE"

# Step 2: Extract only the directory paths
TOP_DIRS=$(awk '{print $2}' "$OUTPUT_FILE")

# Clear the existing content in the output log file
UTILIZED_FILES_OUTPUT="high_utilized_files.log"
> "$UTILIZED_FILES_OUTPUT"

# Step 3: Iterate through each directory and find files larger than 50MB
THRESHOLD=50000000  # 50MB threshold for high utilization

echo "Searching for files larger than 50MB in the top 25 directories..."
for dir in $TOP_DIRS; do
  find "$dir" -type f -size +"$THRESHOLD"c -exec ls -lh {} \; | awk '{print $9 ": " $5}' >> "$UTILIZED_FILES_OUTPUT"
done

echo "High-utilized files have been logged to $UTILIZED_FILES_OUTPUT."
