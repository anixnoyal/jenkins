#!/bin/bash

# Define Jenkins home directory
JENKINS_HOME="/var/lib/jenkins"

# Cleanup workspaces older than 7 days
echo "Cleaning up workspaces older than 7 days..."
find "$JENKINS_HOME/workspace" -type f -mtime +7 -exec rm -f {} \;
find "$JENKINS_HOME/workspace" -type d -empty -delete

# Cleanup caches older than 7 days
echo "Cleaning up caches older than 7 days..."
find "$JENKINS_HOME/plugins/*/cache" -type f -mtime +7 -exec rm -f {} \;
find "$JENKINS_HOME/plugins/*/cache" -type d -empty -delete

# Cleanup temporary files older than 7 days
echo "Cleaning up temporary files older than 7 days..."
find "$JENKINS_HOME/tmp" -type f -mtime +7 -exec rm -f {} \;
find "$JENKINS_HOME/tmp" -type d -empty -delete

echo "Jenkins cleanup completed."
#
