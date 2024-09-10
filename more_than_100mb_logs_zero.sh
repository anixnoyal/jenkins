#!/bin/bash

# Exit if any command fails
set -eu

# Define the log file path based on the script name with .log extension
log_file="/path/to/logs/$(basename "$0" .sh).log"

# Redirect all output (stdout and stderr) to the log file
exec > "$log_file" 2>&1

# Log start time
echo "Script started at: $(date)"

# Find .log files larger than 100MB
find "$SEARCH_DIR" -type f -name "*.log" -size +100M | while read -r logfile; do
    echo "Processing file: $logfile"

    # Check if the log file exists before attempting to process it
    if [ ! -f "$logfile" ]; then
        echo "ERROR: Log file does not exist: $logfile"
        continue
    fi

    # Take the top 100 lines from the log file and append them to the log file
    sudo -u jenkins sh -c "head -n 100 \"$logfile\" >> \"$logfile\""

    # Confirm the operations
    echo "Appended top 100 lines to: $logfile"
done

# Log end time
echo "Script ended at: $(date)"
