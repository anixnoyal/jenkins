#!/bin/bash

# Path to the file containing folder names
folder_list="folders.txt"

# Loop through each folder in the file
while IFS= read -r folder; do
  # Use nohup to run find in the background, excluding .key files
  nohup find "$folder" -type f ! -name "*.key" -print0 | xargs -0 cat > "cat_${folder}.log" 2>&1 &
  echo "Started find and cat for folder: $folder"
done < "$folder_list"
