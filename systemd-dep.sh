sendmail
[Unit]
Before=jenkins.service
After=jenkins.service

jenkins
[Service]
User=jenkins
Group=jenkins
ExecStopPre=/usr/local/bin/jenkins_stop_collect.sh


[Unit]
Before=sendmail.service
After=network.target


systemctl list-dependencies jenkins.service
systemctl list-dependencies sendmail.service


vi /usr/local/bin/jenkins_stop_collect.sh
#!/bin/bash

# Set the directory to store the dumps
DUMP_DIR="/var/lib/jenkins/dumps"
mkdir -p $DUMP_DIR

# Timestamp for file names
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Collect heap dump histogram
jmap -histo $(pgrep -f jenkins) > $DUMP_DIR/heapdump_histo_$TIMESTAMP.txt

# Collect thread dump
jstack $(pgrep -f jenkins) > $DUMP_DIR/threaddump_$TIMESTAMP.txt

# Collect CPU and thread information
top -bH -p $(pgrep -f jenkins) -n 1 > $DUMP_DIR/cpu_threads_$TIMESTAMP.txt


chmod +x /usr/local/bin/jenkins_stop_collect.sh


systemctl list-units --type=service --state=running --no-pager --all --no-legend | awk '{print $1}' | while read -r service; do
    start_time=$(systemctl show "$service" --property=ActiveEnterTimestamp | cut -d'=' -f2)
    echo "$start_time $service"
done | sort

