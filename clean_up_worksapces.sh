This one uses grep to create a whitelist:

ls /var/jenkins_home/workspace \ 
  | grep -v -E '(job-to-skip|another-job-to-skip)$' \
  | xargs -I {} rm -rf /var/jenkins_home/workspace/{}

This one uses du and sort to list workspaces in order of largest to smallest. Then, it uses head to grab the first 10
du -d 1 /var/jenkins_home/workspace \
  | sort -n -r \
  | head -n 10 \
  | xargs -I {} rm -rf /var/jenkins_home/workspace/{}
