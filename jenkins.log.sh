vi /var/cache/jenkins/logging.properties

handlers=java.util.logging.ConsoleHandler, java.util.logging.FileHandler


java.util.logging.FileHandler.level=ALL
java.util.logging.ConsoleHandler.level = ALL
# see https://docs.oracle.com/en/java/javase/17/docs/api/java.logging/java/util/logging/SimpleFormatter.html


# Keep this level to ALL or FINEST or it will be filtered before applying other levels


# Default level
.level= INFO
