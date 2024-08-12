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
