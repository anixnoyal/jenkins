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
