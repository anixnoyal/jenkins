#!/bin/bash

THRESHOLD=90
WAIT_TIME=600  # 10 minutes in seconds

# Get the current CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
echo "Current CPU usage: $CPU_USAGE%"

if (( $(echo "$CPU_USAGE >= $THRESHOLD" | bc -l) )); then
  echo "CPU usage is high. Waiting 10 minutes..."
  sleep $WAIT_TIME

  # Recheck CPU usage after 10 minutes
  CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
  echo "Rechecked CPU usage: $CPU_USAGE%"

  if (( $(echo "$CPU_USAGE >= $THRESHOLD" | bc -l) )); then
    echo "CPU usage still high after 10 minutes. Restarting Jenkins..."
    sudo systemctl restart jenkins
  fi
fi
