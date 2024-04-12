Environment="JENKINS_HOME=/var/lib/jenkins"
Environment="JENKINS_OPTS=--logfile=/mnt/data/jenkins_logs/jenkins.log"

sudo systemctl daemon-reload
sudo systemctl restart jenkins

sudo mv /var/lib/jenkins/jobs /mnt/data/jenkins_jobs/
sudo ln -s /mnt/data/jenkins_jobs/ /var/lib/jenkins/jobs

sudo mv /var/lib/jenkins/workspace /mnt/data/jenkins_workspaces/
sudo ln -s /mnt/data/jenkins_workspaces/ /var/lib/jenkins/workspace
