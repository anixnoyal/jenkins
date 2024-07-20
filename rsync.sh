#!/bin/bash
PS1='\u@\[\033[0;31m\]CustomServerName\[\033[0m\] \# '

# Define source and destination directories for both volumes
SOURCE1="/path/to/volume1/"
DESTINATION1="user@remote_server:/path/to/destination1/"

SOURCE2="/path/to/volume2/"
DESTINATION2="user@remote_server:/path/to/destination2/"

# Define log files
LOG1="/path/to/logs/rsync_volume1.log"
LOG2="/path/to/logs/rsync_volume2.log"
MAIN_LOG="/path/to/logs/rsync_main.log"

# Function to check if any rsync process is running
check_rsync_running() {
    if pgrep -x "rsync" > /dev/null; then
        echo "$(date): Rsync is already running. Exiting script." >> "$MAIN_LOG"
        exit 1
    fi
}

# Initial check to see if any rsync process is running
check_rsync_running

# Run rsync for the first volume
echo "$(date): Starting rsync for $SOURCE1 to $DESTINATION1" >> "$LOG1"
rsync -avz --partial --progress "$SOURCE1" "$DESTINATION1" >> "$LOG1" 2>&1

# Wait for 15 minutes (900 seconds)
sleep 900

# Check if any rsync process is still running before starting the second one
check_rsync_running

# Run rsync for the second volume
echo "$(date): Starting rsync for $SOURCE2 to $DESTINATION2" >> "$LOG2"
rsync -avz --partial --progress "$SOURCE2" "$DESTINATION2" >> "$LOG2" 2>&1 &

# Get the PID of the last background process (the second rsync)
RSYNC_PID=$!

# Monitor the second rsync process
echo "$(date): Monitoring rsync process with PID $RSYNC_PID" >> "$MAIN_LOG"
wait $RSYNC_PID

# Confirm completion of the second rsync process
if [ $? -eq 0 ]; then
    echo "$(date): Rsync for $SOURCE2 to $DESTINATION2 completed successfully." >> "$LOG2"
else
    echo "$(date): Rsync for $SOURCE2 to $DESTINATION2 encountered an error." >> "$LOG2"
fi

echo "$(date): Rsync operations completed for both volumes. Check logs for details." >> "$MAIN_LOG"
