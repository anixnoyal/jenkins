#!/bin/bash

# Main task that runs every 15 minutes
echo "Running main task at $(date)"

# Check if the current time is after 12:00 AM
if [ "$(date +'%H:%M')" \> "00:00" ]; then
    # Command that should run only after 12:00 AM
    echo "Running post-12:00 AM task at $(date)"
    /path/to/specific/command
fi
