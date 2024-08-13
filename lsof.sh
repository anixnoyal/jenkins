#!/bin/bash

# File containing the lsof output
lsof_output_file="/tmp/lsof_output_file.txt"

# List all open files
lsof > $lsof_output_file

# Get the unique list of usernames from the output file (assuming the username is in the 3rd column)
users=$(awk '{print $3}' $output_file | sort | uniq)

# Loop through each user and count open files, network connections, and others
echo "User | Open Files | Network Connections | Other Files | Deleted Files"
echo "----------------------------------------------------------------------------"

for user in $users; do
    # Check if the username starts with a letter (ignore usernames starting with 0-9)
    if [[ ! $user =~ ^[0-9] ]]; then
        # Count all open files for the user
        total_open_files=$(grep "^$user" $output_file | wc -l)
        
        # Count network connections (look for files with 'TCP', 'UDP', etc.)
        network_files=$(grep "^$user" $output_file | grep -E 'TCP|UDP' | wc -l)
        
        # Count regular files (exclude network files and directories)
        regular_files=$(grep "^$user" $output_file | grep -E 'REG|DIR' | wc -l)
        
        # Count other types of files (exclude network and regular files)
        other_files=$(grep "^$user" $output_file | grep -Ev 'TCP|UDP|REG|DIR' | wc -l)
        
        # Count deleted files for the user
        deleted_files=$(grep "^$user" $output_file | grep "(deleted)" | wc -l)
        
        # Display the results in a single line
        echo "$user | $total_open_files | $network_files | $regular_files | $other_files | $deleted_files"
    fi
done
