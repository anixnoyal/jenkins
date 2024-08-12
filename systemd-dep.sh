sendmail
[Unit]
Before=jenkins.service
After=jenkins.service

jenkins
[Service]
User=jenkins
Group=jenkins

[Unit]
Before=sendmail.service
After=network.target


systemctl list-dependencies jenkins.service
systemctl list-dependencies sendmail.service
