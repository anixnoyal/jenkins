#!/bin/bash

# Define the parent directory
PARENT_DIR="/path/to/parent/directory"

# Define the output file
OUTPUT_FILE="/path/to/output_file.txt"

# Clear the output file or create it if it doesn't exist
> "$OUTPUT_FILE"

# Start the script
echo "Finding high-utilization directories..." >> "$OUTPUT_FILE"

# Find high-utilization directories at depth 1 and append to the output file
du -h --max-depth=1 "$PARENT_DIR" | sort -hr | awk '{print $2}' | while read DIR; do
  echo "High-utilization directory: $DIR" >> "$OUTPUT_FILE"
  echo "Listing top 25 files in $DIR..." >> "$OUTPUT_FILE"
  find "$DIR" -maxdepth 1 -type f -exec du -h {} + | sort -rh | head -n 25 >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE" # Add a blank line for readability
done
