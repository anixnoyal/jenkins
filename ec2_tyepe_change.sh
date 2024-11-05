#!/bin/bash

# Variables
INSTANCE_ID="i-1234567890abcdef0"   # Replace with your instance ID
NEW_INSTANCE_TYPE="r6a.4xlarge"     # Desired instance type

# Check if the instance exists
echo "Checking if instance $INSTANCE_ID exists..."
INSTANCE_STATUS=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[*].Instances[*].State.Name' --output text 2>/dev/null)

# Exit if the instance ID is not found
if [ -z "$INSTANCE_STATUS" ]; then
  echo "Error: Instance ID $INSTANCE_ID not found. Exiting."
  exit 1
fi

echo "Instance $INSTANCE_ID found with current state: $INSTANCE_STATUS"

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
