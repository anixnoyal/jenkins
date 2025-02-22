#!/bin/bash

LOCK_FILE="/tmp/jenkins_monitor.lock"

# Function to send email notifications
send_email() {
    SUBJECT=$1
    BODY=$2
    TO_ADDRESS="your_email@example.com"
    INSTANCE_NAME=$(curl -s http://169.254.169.254/latest/meta-data/tags/instance/Name)
    echo -e "$BODY" | mail -s "$SUBJECT - $INSTANCE_NAME" "$TO_ADDRESS"
}

# Function to restart Jenkins
restart_jenkins() {
    INSTANCE_NAME=$(curl -s http://169.254.169.254/latest/meta-data/tags/instance/Name)
    echo "Restarting Jenkins server..."
    systemctl restart jenkins
    STATUS=$?
    if [ $STATUS -eq 0 ]; then
        send_email "Jenkins Restarted" "Jenkins was successfully restarted on $(date) on EC2 instance: $INSTANCE_NAME."
    else
        send_email "Jenkins Restart Failed" "Jenkins restart failed on $(date) on EC2 instance: $INSTANCE_NAME with status code $STATUS."
    fi
}

# Function to expand EBS volume and XFS filesystem
expand_ebs_volume() {
    INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
    INSTANCE_NAME=$(curl -s http://169.254.169.254/latest/meta-data/tags/instance/Name)

    # Get device name for /jn-home
    DEVICE_NAME=$(df /jn-home | tail -1 | awk '{print $1}')

    # Get Volume ID for the device
    VOLUME_ID=$(aws ec2 describe-volumes --filters "Name=attachment.instance-id,Values=$INSTANCE_ID" "Name=attachment.device,Values=$DEVICE_NAME" --query "Volumes[0].VolumeId" --output text)
    echo "Expanding EBS volume $VOLUME_ID for device $DEVICE_NAME..."

    # Increase volume size by 20GB
    CURRENT_SIZE=$(aws ec2 describe-volumes --volume-ids $VOLUME_ID --query "Volumes[0].Size" --output text)
    NEW_SIZE=$((CURRENT_SIZE + 20))
    aws ec2 modify-volume --volume-id $VOLUME_ID --size $NEW_SIZE

    # Wait for volume to finish modification
    while [ "$(aws ec2 describe-volumes-modifications --volume-ids $VOLUME_ID --query 'VolumesModifications[0].ModificationState' --output text)" != "completed" ]; do
        echo "Waiting for volume modification to complete..."
        sleep 10
    done

    # Expand XFS filesystem
    sudo xfs_growfs /jn-home
    echo "EBS volume expanded and filesystem resized."

    send_email "EBS Volume Expanded" "EBS Volume ($VOLUME_ID) expanded to $NEW_SIZE GB on $(date) for EC2 instance: $INSTANCE_NAME and filesystem resized."
}

# Ensure only one instance of the script runs
if [ -e "$LOCK_FILE" ]; then
    echo "Script is already running. Exiting."
    exit 1
fi

touch "$LOCK_FILE"

# Check CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
if (( $(echo "$CPU_USAGE > 90" | bc -l) )); then
    echo "CPU usage is above 90%: $CPU_USAGE%"
    echo "Waiting for 5 minutes before restarting Jenkins..."
    sleep 300
    restart_jenkins
fi

# Check Jenkins process memory usage
JENKINS_PID=$(pgrep -f jenkins)
if [ -n "$JENKINS_PID" ]; then
    JENKINS_MEM=$(ps -o %mem= -p $JENKINS_PID | awk '{print $1}')
    if (( $(echo "$JENKINS_MEM > 90" | bc -l) )); then
        echo "Jenkins memory usage is above 90%: $JENKINS_MEM%"
        echo "Waiting for 5 minutes before restarting Jenkins..."
        sleep 300
        restart_jenkins
    fi

    # Check if Jenkins has been running for more than 15 days and it's Monday at 8 AM
    UPTIME_DAYS=$(ps -p $JENKINS_PID -o etime= | awk -F- '{if (NF==2) print $1; else print 0}')
    CURRENT_DAY=$(date +%u)  # 1 = Monday
    CURRENT_HOUR=$(date +%H)
    CURRENT_MINUTE=$(date +%M)

    if [ "$UPTIME_DAYS" -ge 15 ] && [ "$CURRENT_DAY" -eq 1 ] && [ "$CURRENT_HOUR" -eq 08 ] && [ "$CURRENT_MINUTE" -lt 5 ]; then
        echo "Jenkins has been running for more than 15 days. Restarting as scheduled."
        restart_jenkins
    fi
else
    echo "Jenkins process not found."
fi

# Check /jn-home mount usage
JN_HOME_USAGE=$(df -h /jn-home | awk 'NR==2 {print $5}' | sed 's/%//')
if (( JN_HOME_USAGE > 90 )); then
    echo "/jn-home usage is above 90%: $JN_HOME_USAGE%"
    expand_ebs_volume
    restart_jenkins
fi

# Cleanup lock file
rm -f "$LOCK_FILE"
