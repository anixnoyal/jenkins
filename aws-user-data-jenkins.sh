#!/bin/bash
set -eu
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

keytool -genkeypair -alias myalias -keyalg RSA -keysize 2048 -keystore keystore.jks -validity 365 \
        -dname "CN=www.anix.jenkins.com, OU=IT, O=JENKINS, L=HYD, ST=TS, C=IN" \
        -storepass anixnoyal -keypass anixnoyal

yum install -y jenkins
yum clean all
mkdir -p /var/cache/jenkins/tmp
chown -R jenkins:jenkins /var/cache/jenkins/tmp
mkdir -p /etc/systemd/system/jenkins.service.d
cat > /etc/systemd/system/jenkins.service.d/override.conf <<EOF
[Service]
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djava.net.preferIPv4Stack=true -Djava.io.tmpdir=/var/cache/jenkins/tmp/ -Dorg.apache.commons.jelly.tags.fmt.timeZone=America/New_York -Duser.timezone=America/New_York"
Environment="JENKINS_OPTS=--pluginroot=/var/cache/jenkins/plugins"
Environment="JENKINS_HTTPS_PORT=8443"
Environment="JENKINS_PORT=-1"
Environment="JENKINS_HTTPS_KEYSTORE=/var/cache/jenkins/keystore.jks"
Environment="JENKINS_HTTPS_KEYSTORE_PASSWORD=anixnoyal"
EOF

systemd-analyze verify jenkins.service
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins
systemctl --full status jenkins
journalctl -u jenkins
