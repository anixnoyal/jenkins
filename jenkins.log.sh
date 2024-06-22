vi /var/cache/jenkins/logging.properties

handlers=java.util.logging.ConsoleHandler, java.util.logging.FileHandler

java.util.logging.ConsoleHandler.level=ALL
java.util.logging.ConsoleHandler.formatter=java.util.logging.SimpleFormatter

java.util.logging.FileHandler.level=ALL
java.util.logging.FileHandler.pattern=/var/log/jenkins/jenkins.log
java.util.logging.FileHandler.limit=50000
java.util.logging.FileHandler.count=1
java.util.logging.FileHandler.formatter=java.util.logging.SimpleFormatter
java.util.logging.FileHandler.append=true

org.eclipse.jetty.server.RequestLog.level=ALL
org.eclipse.jetty.server.RequestLog.handler=java.util.logging.FileHandler




while [ "$(aws ec2 describe-volumes-modifications --volume-ids $VOLUME_ID --query "VolumesModifications[0].ModificationState" --output text)" != "completed" ]; do
    sleep 10
    echo -n "."
done
