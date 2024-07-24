JENKINS_JAVA_OPTIONS="-Djenkins.model.Jenkins.scmPollingThreadCount=20"
JENKINS_JAVA_OPTIONS="-Dhudson.remoting.Engine.ioThreadCount=20"
JENKINS_JAVA_OPTIONS="--handlerCountMax=200 --handlerCountMaxIdle=20"


# arguments to pass to java
JENKINS_JAVA_OPTIONS="-Xmx8192m -Djenkins.model.Jenkins.scmPollingThreadCount=50 -Dhudson.remoting.Engine.ioThreadCount=50 --handlerCountMax=200 --handlerCountMaxIdle=20"

JAVA_ARGS="-Dhudson.scm.SCM.checkoutRetryCount=5 -Dorg.eclipse.jetty.util.thread.QueuedThreadPool.maxThreads=200 -Dorg.eclipse.jetty.util.thread.QueuedThreadPool.minThreads=20 -Dorg.eclipse.jetty.util.thread.QueuedThreadPool.idleTimeout=60000"


println hudson.scm.SCM.all().each { scm -> scm.getDescriptor().checkoutRetryCount }


import org.eclipse.jetty.util.thread.QueuedThreadPool
def server = Jenkins.instance.servletContext.getAttribute('org.eclipse.jetty.server.Server')
def threadPool = server.getThreadPool()
if (threadPool instanceof QueuedThreadPool) {
    println "Max Threads: ${threadPool.getMaxThreads()}"
    println "Min Threads: ${threadPool.getMinThreads()}"
    println "Idle Timeout: ${threadPool.getIdleTimeout()}"
}
