import jenkins.model.Jenkins

def jenkins = Jenkins.instance
def server = jenkins.servletContext.getServer()

if (server == null) {
    println "Error: Unable to access Jetty server instance."
} else {
    // Find the Jetty thread pool dynamically
    def threadPool = server.getBeans().find { it.class.name.contains("QueuedThreadPool") }

    if (threadPool) {
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
    } else {
        println "Error: Could not retrieve Jetty thread pool settings. Jetty may not be initialized correctly in this Jenkins instance."
    }
}
