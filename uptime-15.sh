#!/bin/bash
PROCESS_NAME="your_process_name"

OLD_PROCESS=$(ps -eo pid,etimes,cmd | awk -v proc="$PROCESS_NAME" '$2 > 1296000 && $3 ~ proc {print $1}')

if [ ! -z "$OLD_PROCESS" ]; then
    echo "Stopping old process: $OLD_PROCESS"
    kill -9 $OLD_PROCESS
    echo "Restarting process..."
    /path/to/start_process.sh
else
    echo "No old process found."
fi
