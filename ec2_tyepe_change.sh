#!/bin/bash

# Variables
INSTANCE_ID="i-1234567890abcdef0"   # Replace with your instance ID
NEW_INSTANCE_TYPE="r6a.4xlarge"     # Desired instance type

# Stop the instance
echo "Stopping the instance $INSTANCE_ID..."
aws ec2 stop-instances --instance-ids $INSTANCE_ID
echo "Waiting for the instance to stop..."
aws ec2 wait instance-stopped --instance-ids $INSTANCE_ID

# Modify the instance type
echo "Changing instance type to $NEW_INSTANCE_TYPE..."
aws ec2 modify-instance-attribute --instance-id $INSTANCE_ID --instance-type "{\"Value\": \"$NEW_INSTANCE_TYPE\"}"

# Start the instance
echo "Starting the instance $INSTANCE_ID..."
aws ec2 start-instances --instance-ids $INSTANCE_ID
echo "Waiting for the instance to start..."
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

echo "Instance $INSTANCE_ID is now running with type $NEW_INSTANCE_TYPE."
