

rsync -avz --compress --links --exclude='/apps/opt/build_dir' --exclude='*.logs' -e "ssh -o StrictHostKeyChecking=no" /apps/opt/ user@remote:/target/directory/opt/

rsync -avz --compress --links --exclude='*.logs' -e "ssh -o StrictHostKeyChecking=no" /apps/opt/build_dir/ user@remote:/target/directory/build_dir/


#Generate Checksums on the Source Directory:
ssh -i /path/to/private_key user@source_host "cd /path/to/source_directory && find . -type f -exec sha256sum {} +" | sort > source_checksums.txt

#Generate Checksums on the Destination Directory:
ssh -i /path/to/private_key user@remote_host "cd /path/to/destination_directory && find . -type f -exec sha256sum {} +" | sort > destination_checksums.txt

#verify
diff -u source_checksums.txt destination_checksums.txt


#!/bin/bash

# Define the folder path
FOLDER_PATH="/path/to/main/folder"

# Directory to exclude (replace with your directory name)
EXCLUDE_DIR="directory_to_exclude"

# Navigate to the main folder
cd "$FOLDER_PATH"

# Count the number of directories (excluding EXCLUDE_DIR)
num_dirs=$(find . -type d ! -path "./$EXCLUDE_DIR/*" -print | grep -c /)

# Count the number of files (excluding EXCLUDE_DIR)
num_files=$(find . -type f ! -path "./$EXCLUDE_DIR/*" | wc -l)

# Calculate the total size of the main folder (excluding EXCLUDE_DIR)
total_size=$(du -sh --exclude="./$EXCLUDE_DIR" . | cut -f1)

# Get the last modified timestamp of the folder
last_modified=$(stat -c %y "$FOLDER_PATH")

# Display the results
echo "Folder path: $FOLDER_PATH"
echo "Number of directories: $num_dirs"
echo "Number of files: $num_files"
echo "Total size: $total_size"
echo "Last modified: $last_modified"

