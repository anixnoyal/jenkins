#!/bin/bash

# Define the service name
SERVICE_NAME="example-service"

# Check the status of the service
if systemctl is-active --quiet "$SERVICE_NAME"; then
    echo "Service '$SERVICE_NAME' is already running."
else
    echo "Service '$SERVICE_NAME' is not running. Starting it now..."
    
    # Attempt to start the service
    if systemctl start "$SERVICE_NAME"; then
        echo "Service '$SERVICE_NAME' started successfully."
    else
        echo "Failed to start the service '$SERVICE_NAME'. Please check logs for details."
    fi
fi
