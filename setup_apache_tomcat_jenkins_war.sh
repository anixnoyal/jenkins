#!/bin/bash

# Variables
TOMCAT_VERSION="9.0.87"  # Specify the version of Tomcat to install
JENKINS_WAR_URL="http://updates.jenkins-ci.org/latest/jenkins.war"  # Jenkins WAR file URL

# Step 1: Install Apache Tomcat
echo "Installing Apache Tomcat..."
yum update -y
yum install -y wget unzip
wget https://dlcdn.apache.org/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.zip
unzip apache-tomcat-${TOMCAT_VERSION}.zip
mv apache-tomcat-${TOMCAT_VERSION} /opt/tomcat

# Step 2: Download Jenkins WAR
echo "Downloading Jenkins WAR file..."
wget ${JENKINS_WAR_URL} -O /opt/tomcat/webapps/jenkins.war

# Step 3: Create /jenkins context path in Apache Tomcat
# This is handled by placing the Jenkins WAR in the webapps directory as jenkins.war, 
# Tomcat will automatically deploy it under the /jenkins context

# Step 4: Start Jenkins
echo "Starting Jenkins..."
cd /opt/tomcat/bin
chmod +x *.sh
./startup.sh

# Confirming the script execution
echo "Jenkins should now be running on http://localhost:8080/jenkins"
