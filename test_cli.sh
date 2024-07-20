#!/bin/bash

# Check if instance ID is passed as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <instance-id>"
  exit 1
fi

INSTANCE_ID=$1

# Terminate the EC2 instance
echo "Terminating EC2 instance: $INSTANCE_ID"
aws ec2 terminate-instances --instance-ids $INSTANCE_ID

# Verify the termination status
echo "Checking termination status for instance: $INSTANCE_ID"
aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[*].Instances[*].State" --output table
