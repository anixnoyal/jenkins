#!/bin/bash

THRESHOLD=90
WAIT_TIME=600  # 10 minutes in seconds

# Get the current memory usage percentage
MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
echo "Current memory usage: $MEMORY_USAGE%"

if (( $(echo "$MEMORY_USAGE >= $THRESHOLD" | bc -l) )); then
  echo "Memory usage is high. Waiting 10 minutes..."
  sleep $WAIT_TIME

  # Recheck memory usage after 10 minutes
  MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
  echo "Rechecked memory usage: $MEMORY_USAGE%"

  if (( $(echo "$MEMORY_USAGE >= $THRESHOLD" | bc -l) )); then
    echo "Memory usage still high after 10 minutes. Restarting Jenkins..."
    sudo systemctl restart jenkins
  fi
fi
