#!/bin/bash

# Define paths
JENKINS_LOG_PATH="/path/to/jenkins/home/logs/jenkins.log"
CATALINA_LOG_PATH="/path/to/tomcat/logs/catalina.out"

# Create Jenkins logrotate configuration
echo "Creating logrotate configuration for Jenkins..."
cat <<EOL | sudo tee /etc/logrotate.d/jenkins
$JENKINS_LOG_PATH {
    size 100M
    hourly
    rotate 7
    compress
    missingok
    notifempty
    create 644 jenkins jenkins
}
EOL

# Create Catalina logrotate configuration
echo "Creating logrotate configuration for Catalina..."
cat <<EOL | sudo tee /etc/logrotate.d/tomcat
$CATALINA_LOG_PATH {
    size 100M
    hourly
    rotate 7
    compress
    missingok
    copytruncate
    create 644 tomcat tomcat
}
EOL

# Set up hourly cron job for logrotate
echo "Setting up hourly cron job for logrotate..."
sudo tee /etc/cron.hourly/logrotate >/dev/null <<'EOF'
#!/bin/sh
/usr/sbin/logrotate /etc/logrotate.conf
EOF

# Make the cron script executable
sudo chmod +x /etc/cron.hourly/logrotate

echo "Logrotate configuration complete."

#zgrep -iE "error|warning|critical" /path/to/logs/*.gz

