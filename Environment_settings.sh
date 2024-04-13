[Service]
Nice="-19"
Environment="JAVA_OPTS=-Xmx1g -Xms1g -XX:+UseG1GC -XX:G1ReservePercent=20 -XX:InitiatingHeapOccupancyPercent=35 -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:+AlwaysPreTouch -Xlog:gc*:file=/var/log/jenkins/gc.log:time,tags:filecount=10,filesize=10M"
