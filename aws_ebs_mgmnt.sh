#!/bin/bash

# Define variables
disk01="vol-xxxxxxxx"   # Replace with your EBS volume ID for disk01
disk02="vol-yyyyyyyy"   # Replace with your EBS volume ID for disk02
region="us-west-2"      # Replace with your desired AWS region
old_instance_id="i-zzzzzzzz" # Replace with your old EC2 instance ID
new_instance_id="i-aaaaaaa"  # Replace with your new EC2 instance ID

# Detach volumes from the old EC2 instance
echo "Detaching volume $disk01 from instance $old_instance_id in region $region..."
aws ec2 detach-volume --volume-id $disk01 --region $region
if [ $? -ne 0 ]; then
  echo "Failed to detach volume $disk01"
  exit 1
fi

echo "Detaching volume $disk02 from instance $old_instance_id in region $region..."
aws ec2 detach-volume --volume-id $disk02 --region $region
if [ $? -ne 0 ]; then
  echo "Failed to detach volume $disk02"
  exit 1
fi

# Wait for the volumes to be detached
echo "Waiting for volume $disk01 to be detached..."
aws ec2 wait volume-available --volume-ids $disk01 --region $region

echo "Waiting for volume $disk02 to be detached..."
aws ec2 wait volume-available --volume-ids $disk02 --region $region

# Attach volumes to the new EC2 instance
echo "Attaching volume $disk01 to instance $new_instance_id in region $region..."
aws ec2 attach-volume --volume-id $disk01 --instance-id $new_instance_id --device /dev/sdf --region $region
if [ $? -ne 0 ]; then
  echo "Failed to attach volume $disk01"
  exit 1
fi

echo "Attaching volume $disk02 to instance $new_instance_id in region $region..."
aws ec2 attach-volume --volume-id $disk02 --instance-id $new_instance_id --device /dev/sdg --region $region
if [ $? -ne 0 ]; then
  echo "Failed to attach volume $disk02"
  exit 1
fi

# Wait for the volumes to be attached
echo "Waiting for volume $disk01 to be in-use..."
aws ec2 wait volume-in-use --volume-ids $disk01 --region $region

echo "Waiting for volume $disk02 to be in-use..."
aws ec2 wait volume-in-use --volume-ids $disk02 --region $region

# Switch to Jenkins user and start Jenkins service
echo "Switching to Jenkins user and starting Jenkins service..."
sudo -u jenkins bash << EOF
  # Replace the below command with the actual command to start Jenkins service
  sudo systemctl start jenkins
  if [ $? -ne 0 ]; then
    echo "Failed to start Jenkins service"
    exit 1
  fi
EOF

echo "Script execution completed successfully."


# Define the crontab files
root_crontab_file="/path/to/root_crontab.txt"  # Replace with the actual path
jenkins_crontab_file="/path/to/jenkins_crontab.txt"  # Replace with the actual path

# Check if root crontab file exists
if [ -f "$root_crontab_file" ]; then
  echo "Restoring crontab for root user from $root_crontab_file..."
  crontab -u root "$root_crontab_file"
  if [ $? -eq 0 ]; then
    echo "Crontab for root user restored successfully."
  else
    echo "Failed to restore crontab for root user."
  fi
else
  echo "Crontab file for root user not found: $root_crontab_file"
fi

# Check if Jenkins crontab file exists
if [ -f "$jenkins_crontab_file" ]; then
  echo "Restoring crontab for Jenkins user from $jenkins_crontab_file..."
  crontab -u jenkins "$jenkins_crontab_file"
  if [ $? -eq 0 ]; then
    echo "Crontab for Jenkins user restored successfully."
  else
    echo "Failed to restore crontab for Jenkins user."
  fi
else
  echo "Crontab file for Jenkins user not found: $jenkins_crontab_file"
fi

