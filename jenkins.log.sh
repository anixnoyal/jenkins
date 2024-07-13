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


####################### v2
handlers= java.util.logging.ConsoleHandler, java.util.logging.FileHandler

.level=INFO
java.util.logging.ConsoleHandler.level=INFO
java.util.logging.ConsoleHandler.formatter=java.util.logging.SimpleFormatter

# Configuration for the file handler
java.util.logging.FileHandler.level=INFO
java.util.logging.FileHandler.pattern=%h/logs/jenkins.log
#java.util.logging.FileHandler.limit=10000000
java.util.logging.FileHandler.limit=1048576
java.util.logging.FileHandler.count=10
java.util.logging.FileHandler.formatter=java.util.logging.SimpleFormatter
java.util.logging.FileHandler.append=true





##quick config reload
/bin/systemctl kill -s HUP jenkins

-s HUP: Specifies the signal to send. HUP stands for Hang-Up. When HUP is sent to a process, it typically instructs it to reload its configuration or restart gracefully. For systemd services like Jenkins, this signal often triggers a reload of the service's configuration without fully stopping and starting the service.
