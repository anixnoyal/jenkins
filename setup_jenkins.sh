#!/bin/bash
server_name="jenkins-master-01"
echo "$server_name" | tee /etc/hostname
hostnamectl set-hostname $server_name
exit

systemctl disable firewalld
systemctl stop firewalld
setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

dnf update -y
dnf install -y java-11-openjdk-devel mlocate tar wget git
java -version

wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sed -i  's/^gpgcheck=1/gpgcheck=0/g' /etc/yum.repos.d/jenkins.repo
# dnf --showduplicates list jenkins | grep 387
dnf install -y jenkins-2.387.3-1.1
dnf clean packages
systemctl enable jenkins
systemctl start jenkins

cat /var/lib/jenkins/secrets/initialAdminPassword

cp /usr/share/java/jenkins.war /usr/share/jenkins/
cd /usr/share/jenkins/
#PASSWORD_HASH=$(echo -n "anixnoyal" | htpasswd -nB -C 10 -i username | awk -F":" '{print $2}')
#API_TOKEN=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)
cat > /usr/share/jenkins/plugins.txt <<EOF
gitlab-plugin:1.7.14
gitlab-branch-source:664.v877fdc293c89
EOF


curl -L https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.11.0/jenkins-plugin-manager-2.11.0.jar -o /usr/share/jenkins/plugin-manager-cli.jar
java -jar plugin-manager-cli.jar --war /usr/share/jenkins/jenkins.war --plugin-download-directory  /var/lib/jenkins/plugins --plugin-file /usr/share/jenkins/plugins.txt --verbose

systemctl stop jenkins
systemctl start jenkins


### NGROK
cd /root/
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
tar xvzf /root/ngrok-v3-stable-linux-amd64.tgz -C /usr/local/bin
cd /usr/local/bin

#login : https://dashboard.ngrok.com/get-started/setup
ngrok config add-authtoken 2U7fQzeOMCGyXKraWKDiGqk0Yly_6168XnbChk1sD8XEhgQR8
./ngrok http 8080
login page
athentiate 


### gen ssh key
ssh-keygen
cat ~/.ssh/id_rsa.pub




#flow of setup 
Gitlab portal
	1. generate persoanl access token
		glpat-kRzrsoPzVercH3JojF4z
	2. add SSH key
	

Jenkins Server
	1. setup jenkins sever
	2. install necessary plugins
		gitlab
		gitlab authentication
		gitlab API
		login pulgin extension
		gitlab multi branch

	3. setup credentials
		1.  useing gitlab personal token create below credentils 
			a. Add a credentials as "KIND:Gitlab API token" 
			b.Add a credentilas as "KIND:GitLab personal Access token"				
		2. Add credentails as "SSH username with private key" ( get if from OS level)

			
	4. configure system
		1. change global security "git host key verification - no"
		1. Gitlab :
			connection name:
			gitlab hot url:
			credentails : "API Token for accessing Gitlab"
							choose from dropdwon list
		
		2. GitLab Servers
			server url:
			Credentials : "The Personal Access Token for GitLab APIs access"
			
	
	5. create ORG folder and config gitlab project
		




 #####
tcpdump -s 0 -A -i [INTERFACE] 'tcp port 8080 and (tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x47455420 or tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x504F5354)'
http://anixnoyal:116b2d79ef40cae8cf011e0754e931d77c@50c3-49-206-34-69.ngrok-free.app/project/happy-org-folder/





