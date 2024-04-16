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
dnf --showduplicates list jenkins | grep 387
yum install -y jenkins-2.426.2-1.1.noarc
yum versionlock add jenkins-2.426.2-1.1.noarch
dnf clean packages

systemd-analyze verify jenkins.service
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins
systemctl --full status jenkins
journalctl -u jenkins
systemctl stop firewalld
