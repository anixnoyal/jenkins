#!/bin/bash

# Define the parent directory
PARENT_DIR="/path/to/parent/directory"

# Define the output file
OUTPUT_FILE="/path/to/output_file.txt"

# Define the size threshold (in GB)
SIZE_THRESHOLD=5

# Clear the output file or create it if it doesn't exist
> "$OUTPUT_FILE"

# Start the script
echo "Finding high-utilization directories greater than ${SIZE_THRESHOLD}GB..." >> "$OUTPUT_FILE"

# Find high-utilization directories at depth 1 and filter those greater than SIZE_THRESHOLD
du -h --max-depth=1 "$PARENT_DIR" | sort -hr | awk -v threshold="${SIZE_THRESHOLD}" '$1 ~ /G/ && $1+0 >= threshold {print $2}' | while read DIR; do
  echo "High-utilization directory: $DIR" >> "$OUTPUT_FILE"
  echo "Listing top 25 files in $DIR..." >> "$OUTPUT_FILE"
  find "$DIR" -maxdepth 1 -type f -exec du -h {} + | sort -rh | head -n 25 >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE" # Add a blank line for readability
done
