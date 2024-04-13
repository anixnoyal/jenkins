
vi /var/lib/jenkins/logging.properties
handlers=java.util.logging.FileHandler, java.util.logging.ConsoleHandler

.level=INFO

# FileHandler configuration
java.util.logging.FileHandler.level=FINE
java.util.logging.FileHandler.pattern=/var/lib/jenkins/jenkins.log
java.util.logging.FileHandler.append=true
java.util.logging.FileHandler.formatter=java.util.logging.SimpleFormatter

# ConsoleHandler configuration
java.util.logging.ConsoleHandler.level=INFO
java.util.logging.ConsoleHandler.formatter=java.util.logging.SimpleFormatter
