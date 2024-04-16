mkdir -p /etc/systemd/system/jenkins.service.d
cat > /etc/systemd/system/jenkins.service.d/override.conf <<EOF
[Service]
Nice=-19
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djava.net.preferIPv4Stack=true -Xmx1g -Xms1g -XX:+UseG1GC -XX:G1ReservePercent=20 -XX:InitiatingHeapOccupancyPercent=35 -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:+AlwaysPreTouch -Xlog:gc*:file=/var/log/jenkins/gc.log:time,tags:filecount=10,filesize=10M -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/log/jenkins/heapdump.hprof -Djava.io.tmpdir=/var/cache/jenkins/tmp/"
Environment="HOSTNAME=${JENKINS_PREFIX}-`hostname`"
Environment="JENKINS_PREFIX=/jenkins2"
Environment="JENKINS_SESSION_TIMEOUT=60"
Environment="JENKINS_LOG=/var/log/jenkins/jenkins.log"
# Environment="JENKINS_OPTS=--pluginroot=/var/cache/jenkins/plugins"
# Environment="JENKINS_HTTPS_PORT=8443"
# Environment="JENKINS_PORT=-1"
# Environment="JENKINS_HTTPS_KEYSTORE=/var/cache/jenkins/jenkins.jks"
# Environment="JENKINS_HTTPS_KEYSTORE_PASSWORD=mypassword"
EOF

##
mkdir /var/log/jenkins
touch /var/log/jenkins/heapdump.hprof
touch  /var/log/jenkins/jenkins.log
touch /var/log/jenkins/gc.log
chown -R jenkins: /var/log/jenkins

#### list jenkins veriables from script console
System.getenv().each { key, value ->
    println "${key}: ${value}"
}
