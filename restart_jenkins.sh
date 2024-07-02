#!/bin/bash

# Variables
JENKINS_PID=$(pidof java)
DUMPS_DIRECTORY="/var/lib/jenkins"
ARTIFACTORY_URL="http://artifactory.example.com/artifactory/my-repo"
ARTIFACTORY_USER="your_username"
ARTIFACTORY_PASSWORD="your_password"
TIMESTAMP=$(date +%Y%m%d%H%M%S)
JENKINS_START_TIMEOUT=1800  # Timeout in seconds (30 minutes)
JENKINS_CHECK_INTERVAL=60   # Check interval in seconds (1 minute)
NOTIFICATION_EMAIL="admin@example.com"
FROM_EMAIL="sender@example.com"  # Email address to send from

# Function to take thread dump
take_thread_dump() {
    jcmd $JENKINS_PID Thread.print > "$DUMPS_DIRECTORY/jenkins_thread_dump_$TIMESTAMP.txt"
    return $?
}

# Function to take heap dump
take_heap_dump() {
    jcmd $JENKINS_PID GC.heap_dump "$DUMPS_DIRECTORY/jenkins_heap_dump_$TIMESTAMP.hprof"
    return $?
}

# Function to stop sendmail service
stop_sendmail() {
    systemctl stop sendmail
    return $?
}

# Function to clean sendmail queue
clean_sendmail_queue() {
    rm -rf /var/spool/mqueue/*
    return $?
}

# Function to start sendmail service
start_sendmail() {
    systemctl start sendmail
    return $?
}

# Function to stop Jenkins service
stop_jenkins() {
    systemctl stop jenkins
    return $?
}

# Function to start Jenkins service with retry
start_jenkins() {
    systemctl start jenkins
    local retries=$((JENKINS_START_TIMEOUT / JENKINS_CHECK_INTERVAL))
    local i=0
    while [[ $i -lt $retries ]]; do
        systemctl is-active --quiet jenkins && return 0
        sleep $JENKINS_CHECK_INTERVAL
        ((i++))
    done
    return 1
}

# Function to create tar.gz of dumps
create_tar_archive() {
    tar -czf "$DUMPS_DIRECTORY/jenkins_dumps_${HOSTNAME}_${TIMESTAMP}.tar.gz" \
        "$DUMPS_DIRECTORY/jenkins_thread_dump_${HOSTNAME}_${TIMESTAMP}.txt" \
        "$DUMPS_DIRECTORY/jenkins_heap_dump_${HOSTNAME}_${TIMESTAMP}.hprof"
    return $?
}

# Function to upload tar.gz to Artifactory
upload_to_artifactory() {
    curl -u "$ARTIFACTORY_USER:$ARTIFACTORY_PASSWORD" \
         -T "$DUMPS_DIRECTORY/jenkins_dumps_${HOSTNAME}_${TIMESTAMP}.tar.gz" \
         "$ARTIFACTORY_URL/jenkins_dumps_${HOSTNAME}_${TIMESTAMP}.tar.gz"
    return $?
}

# Function to remove dumps and tar.gz after upload
cleanup_files() {
    rm -f "$DUMPS_DIRECTORY/jenkins_thread_dump_${HOSTNAME}_${TIMESTAMP}.txt" \
          "$DUMPS_DIRECTORY/jenkins_heap_dump_${HOSTNAME}_${TIMESTAMP}.hprof" \
          "$DUMPS_DIRECTORY/jenkins_dumps_${HOSTNAME}_${TIMESTAMP}.tar.gz"
    return $?
}

# Function to send notification email
send_notification_email() {
    df_output=$(df -hT)
    jenkins_status=$(systemctl status jenkins)
    
    # Constructing email content
    email_subject="Jenkins Maintenance Notification"
    echo -e "Jenkins maintenance tasks completed.\n\n"\
             "Filesystem Disk Usage:\n$df_output\n\n"\
             "Jenkins Status:\n$jenkins_status" \
    > "$EMAIL_BODY_FILE"

    # Sending email using mail command
    echo -e "$email_body" | mail -s "$email_subject" -r "$FROM_EMAIL" "$NOTIFICATION_EMAIL"
    
    return $?
}


# Main script execution

# Perform maintenance tasks
take_thread_dump && \
take_heap_dump && \
stop_sendmail && \
clean_sendmail_queue && \
stop_jenkins && \
start_jenkins && \
start_sendmail && \
create_tar_archive && \
upload_to_artifactory && \
cleanup_files

# Check if all tasks were successful
if [[ $? -eq 0 ]]; then
    echo "Jenkins maintenance tasks completed successfully."
    send_notification_email
else
    echo "Jenkins maintenance tasks failed."
fi

# Exit with appropriate status
exit $?
