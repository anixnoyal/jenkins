
sudo rsync -avz /var/bli/jenkins/ /jn-home-anix/
sudo mv /var/bli/jenkins /var/bli/jenkins_backup
sudo ln -s /jn-home-anix /var/bli/jenkins
