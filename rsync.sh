

rsync -avz --compress --links --exclude='/apps/opt/build_dir' --exclude='*.logs' -e "ssh -o StrictHostKeyChecking=no" /apps/opt/ user@remote:/target/directory/opt/

rsync -avz --compress --links --exclude='*.logs' -e "ssh -o StrictHostKeyChecking=no" /apps/opt/build_dir/ user@remote:/target/directory/build_dir/


#Generate Checksums on the Source Directory:
ssh -i /path/to/private_key user@source_host "cd /path/to/source_directory && find . -type f -exec sha256sum {} +" | sort > source_checksums.txt

#Generate Checksums on the Destination Directory:
ssh -i /path/to/private_key user@remote_host "cd /path/to/destination_directory && find . -type f -exec sha256sum {} +" | sort > destination_checksums.txt

#verify
diff -u source_checksums.txt destination_checksums.txt
