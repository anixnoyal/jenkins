#!/bin/bash

# Log file for tracking script activity
LOG_FILE="/var/log/jenkins_mem_monitor.log"

# Threshold
MEM_THRESHOLD=85
WAIT_TIME=5    # Wait time in minutes before rebooting if condition persists

# Get the PID of the Jenkins process
PID=$(pgrep -f jenkins)

# Check if Jenkins is running
if [ -z "$PID" ]; then
    echo "$(date): Jenkins is not running!" >> "$LOG_FILE"
    exit 1
fi

echo "$(date): Monitoring Jenkins process with PID $PID" >> "$LOG_FILE"

# Get current memory usage of the Jenkins process
MEM_USAGE=$(ps -p "$PID" -o %mem --no-headers | awk '{print $1}')

# Log memory usage
echo "$(date): Jenkins Memory Usage: ${MEM_USAGE}%" >> "$LOG_FILE"

# Check if Jenkins memory usage exceeds threshold
if [ "$(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc)" -eq 1 ]; then
    echo "$(date): Jenkins memory usage exceeded ${MEM_THRESHOLD}%. Waiting for 5 minutes..." >> "$LOG_FILE"
    sleep 300  # Wait for 5 minutes before checking again
    MEM_USAGE=$(ps -p "$PID" -o %mem --no-headers | awk '{print $1}')
    if [ "$(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc)" -eq 1 ]; then
        echo "$(date): Jenkins memory usage still exceeded ${MEM_THRESHOLD}%. Rebooting server..." >> "$LOG_FILE"
        sudo reboot
        exit 0  # Exit after reboot to avoid further script execution
    fi
fi
