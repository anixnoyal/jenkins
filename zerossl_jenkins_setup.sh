#!/bin/bash
set -eu
systemctl disable firewalld
systemctl stop firewalld
setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

yum update -y
yum install -y fontconfig java-17 mlocate tar wget git yum-plugin-versionlock lsof 
java -version

wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

yum install -y jenkins
yum clean all
mkdir -p /var/cache/jenkins/tmp
chown -R jenkins:jenkins /var/cache/jenkins/tmp

#update zerossl keys to /tmp

openssl pkcs12 -export -in certificate.crt -inkey private.key -certfile ca_bundle.crt -out keystore.p12 -name jenkins -password pass:anixnoyal

keytool -importkeystore \
        -srckeystore keystore.p12 \
        -srcstoretype PKCS12 \
        -srcstorepass anixnoyal \
        -destkeystore jenkins.jks \
        -deststoretype JKS \
        -deststorepass anixnoyal \
        -destkeypass anixnoyal 

cp jenkins.jks /var/cache/jenkins/

mkdir -p /etc/systemd/system/jenkins.service.d
cat > /etc/systemd/system/jenkins.service.d/override.conf <<EOF
[Service]
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djava.net.preferIPv4Stack=true -Djava.io.tmpdir=/var/cache/jenkins/tmp/ -Dorg.apache.commons.jelly.tags.fmt.timeZone=America/New_York -Duser.timezone=America/New_York"
Environment="JENKINS_OPTS=--pluginroot=/var/cache/jenkins/plugins"
Environment="JENKINS_HTTPS_PORT=8443"
Environment="JENKINS_PORT=-1"
Environment="JENKINS_HTTPS_KEYSTORE=/var/cache/jenkins/jenkins.jks"
Environment="JENKINS_HTTPS_KEYSTORE_PASSWORD=anixnoyal"
EOF
  
systemd-analyze verify jenkins.service
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins
systemctl --full status jenkins
journalctl -u jenkins
systemctl stop firewalld
