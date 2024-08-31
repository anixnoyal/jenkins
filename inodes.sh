find . -type d -exec du -a --inodes {} + | sort -n -r | head -n 20
find $JENKINS_HOME/jobs/<job_name>/ -type f | wc -l


while true; do
    date >> inode_usage.log
    find $JENKINS_HOME/jobs/* -maxdepth 0 -type d -exec du -a --inodes {} + | sort -n -r >> inode_usage.log
    sleep 3600  # Run every hour
done
