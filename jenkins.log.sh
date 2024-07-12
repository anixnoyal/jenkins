vi /var/cache/jenkins/logging.properties

handlers=java.util.logging.ConsoleHandler, java.util.logging.FileHandler
java.util.logging.SimpleFormatter.format = [%1$tF %1$tT][%4$-6s][%2$s] %5$s %6$s %n

java.util.logging.ConsoleHandler.level = ALL

# handlers=java.util.logging.FileHandler
java.util.logging.FileHandler.pattern=/var/log/jenkins/jenkins.log
java.util.logging.FileHandler.formatter=java.util.logging.SimpleFormatter

#
# Default level
.level= INFO
#.level= ALL


##quick config reload
/bin/systemctl kill -s HUP jenkins

-s HUP: Specifies the signal to send. HUP stands for Hang-Up. When HUP is sent to a process, it typically instructs it to reload its configuration or restart gracefully. For systemd services like Jenkins, this signal often triggers a reload of the service's configuration without fully stopping and starting the service.
