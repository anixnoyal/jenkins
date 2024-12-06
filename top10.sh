#!/bin/bash

# Define the Jenkins jobs directory
JOBS_DIR="/var/lib/jenkins/jobs"

# Check if the directory exists
if [ ! -d "$JOBS_DIR" ]; then
    echo "Error: Directory $JOBS_DIR does not exist."
    exit 1
fi

# Temporary file for storing results
TEMP_FILE=$(mktemp)

# Header for the report
echo "Top 10 Utilized Folders in $JOBS_DIR" > "$TEMP_FILE"
echo "----------------------------------------------------------" >> "$TEMP_FILE"

# Find top 10 folders by size
TOP_FOLDERS=$(du -sh "$JOBS_DIR"/* 2>/dev/null | sort -rh | head -n 10)

# Iterate through each of the top folders
echo "$TOP_FOLDERS" | while read -r SIZE FOLDER; do
    echo "" >> "$TEMP_FILE"
    echo "Folder: $FOLDER (Size: $SIZE)" >> "$TEMP_FILE"
    echo "----------------------------------------------------------" >> "$TEMP_FILE"

    # Find top 10 subfolders by size within this folder
    TOP_SUBFOLDERS=$(du -sh "$FOLDER"/* 2>/dev/null | sort -rh | head -n 10)

    if [ -z "$TOP_SUBFOLDERS" ]; then
        echo "No subfolders found in $FOLDER" >> "$TEMP_FILE"
    else
        echo "$TOP_SUBFOLDERS" | while read -r SUBSIZE SUBFOLDER; do
            echo "  $SUBFOLDER: $SUBSIZE" >> "$TEMP_FILE"
        done
    fi
done

# Print the final report
cat "$TEMP_FILE"

# Cleanup
rm -f "$TEMP_FILE"
