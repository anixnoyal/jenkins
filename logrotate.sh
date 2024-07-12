/var/log/jenkins/jenkins.log {
    daily
    rotate 7
    compress
    missingok
    notifempty
    copytruncate
    create 0644 jenkins jenkins
    postrotate
        systemctl restart jenkins > /dev/null
    endscript
}


#!/bin/bash

# Define the log file path
LOG_FILE="/var/log/jenkins/jenkins.log"

# Calculate bytes for 20MB
BYTES_20MB=$((20 * 1024 * 1024))

# Get the size of the log file in bytes
LOG_SIZE_BYTES=$(stat -c%s "$LOG_FILE")

# Perform action if log file size exceeds 20MB
if [ "$LOG_SIZE_BYTES" -gt "$BYTES_20MB" ]; then
    echo "Log file size exceeds 20MB. Performing logrotate and truncating..."
    /usr/sbin/logrotate -f /etc/logrotate.conf
    echo > "$LOG_FILE"
else
    echo "Log file size is within acceptable limits."
fi
