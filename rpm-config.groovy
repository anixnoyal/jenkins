import jenkins.model.Jenkins

def jenkins = Jenkins.instance

try {
    // Get Jetty Server instance dynamically
    def server = jenkins.servletContext.getServer() ?: jenkins.servletContext.getAttribute("org.eclipse.jetty.server.Server")

    if (server == null) {
        println "Error: Unable to access Jetty server instance. It may not be available in this Jenkins version."
    } else {
        // Dynamically find the Jetty thread pool
        def threadPool = server.getBeans().find { it.class.name.toLowerCase().contains("queuedthreadpool") }

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
            println "Error: Could not retrieve Jetty thread pool settings. Jetty may be running differently in this Jenkins version."
        }
    }
} catch (Exception e) {
    println "Error retrieving Jetty settings: ${e.message}"
}
