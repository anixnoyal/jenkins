import org.eclipse.jetty.util.thread.QueuedThreadPool
import jenkins.model.Jenkins

def server = Jenkins.instance.servletContext.server
def threadPool = server.getBean(QueuedThreadPool)

// Get Jetty Thread Pool Details
def maxThreads = threadPool.getMaxThreads()
def minThreads = threadPool.getMinThreads()
def idleTimeout = threadPool.getIdleTimeout()

// Get Jetty Request Buffer Size
def requestBufferSize = System.getProperty("org.eclipse.jetty.server.Request.maxFormContentSize", "Default (200KB)")

// Check HTTP Keep-Alive
def keepAlive = System.getProperty("org.eclipse.jetty.server.HttpChannelState.DEFAULT_KEEP_ALIVE", "Not Set (Default: true)")

// Print Results
println "===== Jetty Configuration ====="
println "Jetty Thread Pool Size: ${maxThreads}"
println "Jetty Min Threads: ${minThreads}"
println "Jetty Idle Timeout (ms): ${idleTimeout}"
println "Jetty Request Buffer Size: ${requestBufferSize}"
println "Jetty Keep-Alive Enabled: ${keepAlive}"
println "================================"
