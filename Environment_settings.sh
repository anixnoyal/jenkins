[Service]
Nice=-19
Environment="JAVA_OPTS=-Xmx1g -Xms1g -XX:+UseG1GC -XX:G1ReservePercent=20 -XX:InitiatingHeapOccupancyPercent=35 -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:+AlwaysPreTouch -Xlog:gc*:file=/var/log/jenkins/gc.log:time,tags:filecount=10,filesize=10M -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/log/jenkins/heapdump.hprof"
Environment="JENKINS_PREFIX=/jenkins2"
Environment="HOSTNAME=${JENKINS_PREFIX}-`hostname`"
Environment="JENKINS_LOG_PATH=/var/log/jenkins/jenkins.log"
