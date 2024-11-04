#!/bin/bash

# Define the base directory of your Jenkins workspace (change as needed)
BASE_DIR="/var/lib/jenkins"

# Step 1: Find the top 25 largest directories within the Jenkins workspace and save the output to a file
OUTPUT_FILE="top_25_dirs.txt"
echo "Finding top 25 largest directories in $BASE_DIR..."
du -ah --max-depth=1 "$BASE_DIR" 2>/dev/null | sort -rh | head -n 25 > "$OUTPUT_FILE"

# Display the top directories
echo "Top 25 directories by disk usage have been written to $OUTPUT_FILE."
cat "$OUTPUT_FILE"

# Step 2: Use a for loop to read the top 25 directories from the file and list high-utilized files into a file
THRESHOLD=50000000  # 50MB threshold for high utilization
UTILIZED_FILES_OUTPUT="high_utilized_files.txt"

# Clear the existing content in the output file (if any)
> "$UTILIZED_FILES_OUTPUT"

echo "Listing high-utilized files in the top 25 directories..."
for dir in $(awk '{print $2}' "$OUTPUT_FILE"); do
  echo "Files larger than 50MB in directory: $dir" | tee -a "$UTILIZED_FILES_OUTPUT"
  find "$dir" -type f -size +"$THRESHOLD"c -exec ls -lh {} \; | awk '{print $9 ": " $5}' | tee -a "$UTILIZED_FILES_OUTPUT"
  echo | tee -a "$UTILIZED_FILES_OUTPUT"
done

echo "High-utilized files have been saved to $UTILIZED_FILES_OUTPUT."
