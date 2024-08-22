#!/bin/bash

# Define directories and retention period
WORKSPACE_DIR="/var/lib/jenkins/workspace"
CACHE_DIR="/var/lib/jenkins/cache"
TMP_DIR="/var/lib/jenkins/tmp"
RETENTION_DAYS=7

# Cleanup function
cleanup() {
    local DIR=$1
    echo "Cleaning up $DIR older than $RETENTION_DAYS days..."
    find "$DIR" -type f -mtime +$RETENTION_DAYS -exec rm -f {} \;
    find "$DIR" -type d -empty -delete
    echo "Cleanup complete for $DIR"
}

# Clean specific directories
cleanup "$WORKSPACE_DIR"
cleanup "$CACHE_DIR"
cleanup "$TMP_DIR"
