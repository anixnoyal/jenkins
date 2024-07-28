rsync -avz --compress-level=9 --sockopts=SO_SNDBUF=16777216,SO_RCVBUF=16777216 --block-size=16777216 -e 'ssh -T -c aes256-gcm@openssh.com -o Compression=no -o TCP_NODELAY=yes' source/ destination/
