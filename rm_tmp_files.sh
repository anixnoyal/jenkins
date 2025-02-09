#!/bin/bash

# Find files older than 1 day
files=( $(find /tmp -type f -name "mavenbuild*" -mtime +1) )

for file in "${files[@]}"; do
    # Check if the file is in use
    if ! lsof "$file" > /dev/null 2>&1; then
        echo "Deleting: $file"
        rm -f "$file"
    else
        echo "Skipping (in use): $file"
    fi
done
