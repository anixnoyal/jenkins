#!/bin/bash
server_name="jenkins-master-01"
echo "$server_name" | tee /etc/hostname
hostnamectl set-hostname $server_name
exit

systemctl disable firewalld
systemctl stop firewalld
setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

yum update -y
yum install -y fontconfig java-17-openjdk-devel mlocate tar wget git yum-plugin-versionlock lsof 
java -version

wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

#sed -i  's/^gpgcheck=1/gpgcheck=0/g' /etc/yum.repos.d/jenkins.repo
# dnf --showduplicates list jenkins | grep 387
yum install -y jenkins-2.426.2-1.1.noarc
yum versionlock add jenkins-2.426.2-1.1.noarch
dnf clean packages

systemctl enable jenkins
systemctl start jenkins
systemctl status jenkins

journalctl -u jenkins

#######################

cat /var/lib/jenkins/secrets/initialAdminPassword

cp /usr/share/java/jenkins.war /usr/share/jenkins/
cd /usr/share/jenkins/
#PASSWORD_HASH=$(echo -n "anixnoyal" | htpasswd -nB -C 10 -i username | awk -F":" '{print $2}')
#API_TOKEN=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)
cat > /usr/share/jenkins/plugins.txt <<EOF
gitlab-plugin:1.7.14
gitlab-branch-source:664.v877fdc293c89
EOF

systemctl stop jenkins
curl -L https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.11.0/jenkins-plugin-manager-2.11.0.jar -o /usr/share/jenkins/plugin-manager-cli.jar
java -jar plugin-manager-cli.jar --war /usr/share/jenkins/jenkins.war --plugin-download-directory  /var/lib/jenkins/plugins --plugin-file /usr/share/jenkins/plugins.txt --verbose
systemctl start jenkins

 #####
tcpdump -s 0 -A -i [INTERFACE] 'tcp port 8080 and (tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x47455420 or tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x504F5354)'
http://anixnoyal:116b2d79ef40cae8cf011e0754e931d77c@50c3-49-206-34-69.ngrok-free.app/project/happy-org-folder/
