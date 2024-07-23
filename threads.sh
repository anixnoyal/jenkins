JENKINS_JAVA_OPTIONS="-Djenkins.model.Jenkins.scmPollingThreadCount=20"
JENKINS_JAVA_OPTIONS="-Dhudson.remoting.Engine.ioThreadCount=20"
JENKINS_JAVA_OPTIONS="--handlerCountMax=200 --handlerCountMaxIdle=20"


# arguments to pass to java
JENKINS_JAVA_OPTIONS="-Xmx8192m -Djenkins.model.Jenkins.scmPollingThreadCount=50 -Dhudson.remoting.Engine.ioThreadCount=50 --handlerCountMax=200 --handlerCountMaxIdle=20"

