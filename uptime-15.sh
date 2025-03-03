#!/bin/bash

PROCESS_NAME="your_process_name"
DAYS_LIMIT=15  
SCRIPT_TO_RUN="/path/to/your_script.sh"

# Get process running time in days
read PID RUNNING_DAYS < <(ps -eo pid,etimes,cmd --no-header | awk -v proc="$PROCESS_NAME" '$3 ~ proc {print $1, int($2/86400); exit}')

if [[ -z "$PID" ]]; then
    echo "Process not running."
    exit 1
fi

if (( RUNNING_DAYS > DAYS_LIMIT )); then
    echo "Process $PID ($PROCESS_NAME) running for $RUNNING_DAYS days. Executing script..."
    bash "$SCRIPT_TO_RUN"
else
    echo "Process $PID ($PROCESS_NAME) running for $RUNNING_DAYS days. No action needed."
fi
