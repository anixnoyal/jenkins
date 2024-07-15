

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

# Directories to exclude (replace with your directory names)
EXCLUDE_DIRS=(
    "directory_to_exclude1"
    "directory_to_exclude2"
    "directory_to_exclude3"
)

# Navigate to the main folder
cd "$FOLDER_PATH"

# Function to generate --exclude options for rsync
generate_exclude_options() {
    local exclude_opts=()
    for dir in "${EXCLUDE_DIRS[@]}"; do
        exclude_opts+=("--exclude=/$dir/")
    done
    # Exclude .log files as well
    exclude_opts+=("--exclude=*.log")
    echo "${exclude_opts[@]}"
}

# Count the number of directories (excluding EXCLUDE_DIRS)
num_dirs=$(find . -type d "${EXCLUDE_DIRS[@]/#/! -path .\/}" -print | grep -c /)

# Count the number of files (excluding EXCLUDE_DIRS and *.log files)
num_files=$(find . -type f "${EXCLUDE_DIRS[@]/#/! -path .\/}" ! -name '*.log' | wc -l)

# Calculate the total size of the main folder (excluding EXCLUDE_DIRS and *.log files)
total_size=$(du -sh --exclude=$(IFS=, ; echo "${EXCLUDE_DIRS[*]}") . | grep -v '\.log$' | cut -f1)

# Get the last modified timestamp of the folder
last_modified=$(stat -c %y "$FOLDER_PATH")

# Display the results
echo "Folder path: $FOLDER_PATH"
echo "Number of directories: $num_dirs"
echo "Number of files: $num_files"
echo "Total size: $total_size"
echo "Last modified: $last_modified"
