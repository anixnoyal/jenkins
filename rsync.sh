

rsync -avz --compress --links --exclude='/apps/opt/build_dir' --exclude='*.logs' -e "ssh -o StrictHostKeyChecking=no" /apps/opt/ user@remote:/target/directory/opt/

rsync -avz --compress --links --exclude='*.logs' -e "ssh -o StrictHostKeyChecking=no" /apps/opt/build_dir/ user@remote:/target/directory/build_dir/
