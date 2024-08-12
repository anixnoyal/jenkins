
#This one uses grep to create a whitelist:

ls /var/jenkins_home/workspace \ 
  | grep -v -E '(job-to-skip|another-job-to-skip)$' \
  | xargs -I {} rm -rf /var/jenkins_home/workspace/{}

#This one uses du and sort to list workspaces in order of largest to smallest. Then, it uses head to grab the first 10
du -d 1 /var/jenkins_home/workspace \
  | sort -n -r \
  | head -n 10 \
  | xargs -I {} rm -rf /var/jenkins_home/workspace/{}


#!/bin/bash

# Directories to search
WORKSPACE_DIR="/var/lib/jenkins/workspace"
CACHES_DIR="/var/lib/jenkins/caches"

# Log file to store the list of files and directories to be deleted
LOG_FILE="/var/log/jenkins_cleanup_$(date +'%Y%m%d_%H%M%S').log"

# Find files older than 3 days and save to log
find "$WORKSPACE_DIR" "$CACHES_DIR" -type f -mtime +3 -print > "$LOG_FILE"

# Find empty directories older than 3 days and append to log
find "$WORKSPACE_DIR" "$CACHES_DIR" -type d -empty -mtime +3 -print >> "$LOG_FILE"

# Remove the files and directories listed in the log
cat "$LOG_FILE" | xargs rm -rf
