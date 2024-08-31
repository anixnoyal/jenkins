#!/bin/bash

# Directory to search for log files
LOG_DIR="/path/to/logs"
BACKUP_DIR="/path/to/backup"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Find log files larger than 100 MB and process them
find "$LOG_DIR" -type f -name "*.log" -size +100M | while read -r file; do
  echo "Processing $file"

  # Step 2: Copy the log file to the backup directory
  cp "$file" "$BACKUP_DIR"

  # Step 3: Create a temporary file with the top 100 lines
  su -s /bin/bash jenkins -c "head -n 100 \"$file\" > \"/tmp/temp_log_file\""

  # Step 3: Replace the original file with only the top 100 lines
  su -s /bin/bash jenkins -c "cat \"/tmp/temp_log_file\" > \"$file\""

  # Cleanup temporary file
  rm -f /tmp/temp_log_file

done
