/var/log/jenkins/jenkins.log {
    daily
    rotate 7
    compress
    missingok
    notifempty
    copytruncate
    create 0644 jenkins jenkins
    postrotate
        systemctl restart jenkins > /dev/null
    endscript
}
