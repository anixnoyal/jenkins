#!/bin/bash

# File containing the lsof output
lsof_output_file="/tmp/lsof_output_file.txt"

# List all open files
lsof > $lsof_output_file

# Count Java open files from the lsof output file
java_open_files=$(grep -c 'java' $lsof_output_file)

# Count deleted files for Java processes from the lsof output file
java_deleted_files=$(grep 'java' $lsof_output_file | grep -c "(deleted)")

# Count deleted files for OS-related processes from the lsof output file
os_deleted_files=$(grep -v 'java' $lsof_output_file | grep -c "(deleted)")


# Display the counts
echo "Java open files: $java_open_files"
echo "Java deleted files: $java_deleted_files"
echo "OS-related deleted files: $os_deleted_files"



#!/bin/bash

# File containing the lsof output
output_file="/path/to/output_file.txt"

# Get the unique list of usernames from the output file (assuming the username is in the 3rd column)
users=$(awk '{print $3}' $output_file | sort | uniq)

# Loop through each user and count open and deleted files
echo "User | Open Files | Deleted Files"
echo "------------------------------------"

for user in $users; do
    # Count open files for the user
    open_files=$(grep "^$user" $output_file | wc -l)
    
    # Count deleted files for the user
    deleted_files=$(grep "^$user" $output_file | grep "(deleted)" | wc -l)
    
    # Display the results in a single line
    echo "$user | $open_files | $deleted_files"
done
