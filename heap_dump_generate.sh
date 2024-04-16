
cd /tmp && /usr/bin/jmap -dump:live,format=b,file=heapdump-$(date +%Y%m%d%H%M%S).hprof $(pgrep -f jenkins)
