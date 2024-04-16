jmap -dump:live,format=b,file=heapdump.hprof-$(date +%Y-%m-%d_%H-%M-%S) $(pgrep -f jenkins)
