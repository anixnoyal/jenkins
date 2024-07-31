#!/bin/bash

# Jenkins server URL and credentials
JENKINS_URL="http://your-jenkins-server"
JENKINS_USER="your-username"
JENKINS_API_TOKEN="your-api-token"

# Log file for recording metrics
LOG_FILE="/path/to/jenkins_metrics.log"

# Function to log data with timestamp
log_data() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# System resource monitoring
log_data "CPU Usage: $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')"
log_data "Memory Usage: $(free -m | awk '/Mem:/ {printf("%d/%dMB (%.2f%%)", $3, $2, $3/$2 * 100.0)}')"
log_data "Disk Usage: $(df -h | grep '/$' | awk '{print $5}')"
log_data "Network Usage: $(vnstat --oneline | awk -F\; '{print $9}')"

# Jenkins-specific metrics
# Get the number of executors
executors=$(curl -s --user "$JENKINS_USER:$JENKINS_API_TOKEN" "$JENKINS_URL/computer/api/json" | jq '.totalExecutors')
log_data "Total Executors: $executors"

# Get the number of jobs in the queue
queue_length=$(curl -s --user "$JENKINS_USER:$JENKINS_API_TOKEN" "$JENKINS_URL/queue/api/json" | jq '.items | length')
log_data "Build Queue Length: $queue_length"

# Get the number of running jobs
running_jobs=$(curl -s --user "$JENKINS_USER:$JENKINS_API_TOKEN" "$JENKINS_URL/computer/api/json" | jq '[.computer[] | .executors[].currentExecutable] | length')
log_data "Running Jobs: $running_jobs"

# Get Jenkins uptime
uptime=$(curl -s --user "$JENKINS_USER:$JENKINS_API_TOKEN" "$JENKINS_URL/api/json" | jq '.quietingDown')
log_data "Jenkins Uptime: $uptime"

# Plugin status (example for a specific plugin)
plugin_status=$(curl -s --user "$JENKINS_USER:$JENKINS_API_TOKEN" "$JENKINS_URL/pluginManager/api/json?depth=1" | jq '.plugins[] | select(.shortName=="your-plugin-name") | .active')
log_data "Plugin Status: $plugin_status"

echo "---------------------------------------------" >> "$LOG_FILE"
