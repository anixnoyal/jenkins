#!/bin/bash

# Log file for tracking script activity
LOG_FILE="/var/log/cpu_monitor.log"

# Threshold
CPU_THRESHOLD=85
WAIT_TIME=5    # Wait time in minutes before rebooting if condition persists

# Get current CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')

# Log CPU usage
echo "$(date): CPU Usage: ${CPU_USAGE}%" >> "$LOG_FILE"

# Check if CPU usage exceeds threshold
if [ "$(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc)" -eq 1 ]; then
    echo "$(date): CPU usage exceeded ${CPU_THRESHOLD}%. Waiting for 5 minutes..." >> "$LOG_FILE"
    sleep 300  # Wait for 5 minutes before checking again
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    if [ "$(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc)" -eq 1 ]; then
        echo "$(date): CPU usage still exceeded ${CPU_THRESHOLD}%. Rebooting server..." >> "$LOG_FILE"
        sudo reboot
        exit 0  # Exit after reboot to avoid further script execution
    fi
fi
