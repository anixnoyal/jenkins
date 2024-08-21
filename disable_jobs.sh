#!/bin/bash
#getfacl -R /path/to/backup > acl_backup.txt
#setfacl --restore=acl_backup.txt
# Define file names, default permissions, and root directory
PATTERN_FILE="search_pattern.txt"
OUTPUT_FILE="directories_list.txt"
PERMISSION="500"
ROOT_DIR="/absolute/path/to/check"  

# Check if the pattern file exists and is not empty
if [ ! -s "$PATTERN_FILE" ]; then
    echo "Pattern file $PATTERN_FILE is empty or does not exist. Please add the search patterns."
    exit 1
fi

# Clear the output file if it exists
> "$OUTPUT_FILE"

# Read and process each search pattern from the file
for SEARCH_PATTERN in $(cat "$PATTERN_FILE"); do
    if [ -n "$SEARCH_PATTERN" ]; then
        # Find directories containing the search pattern and append them to the output file
        find "$ROOT_DIR" -type d -name "*.$SEARCH_PATTERN.*" >> "$OUTPUT_FILE"
    fi
done

# Check if the output file is not empty
if [ -s "$OUTPUT_FILE" ]; then
    # Use a for loop to iterate through each directory listed in the file
    for directory in $(cat "$OUTPUT_FILE"); do
        chmod -R "$PERMISSION" "$directory"
        echo "Changed permissions to $PERMISSION for $directory"
    done
    echo "Permissions have been updated for all directories listed in $OUTPUT_FILE."
else
    echo "No directories found matching the patterns in '$PATTERN_FILE' or the $OUTPUT_FILE is empty."
fi
#
