import jenkins.model.Jenkins

def jenkins = Jenkins.instance

try {
    // Find the Jetty Server instance dynamically
    def server = jenkins.servletContext.getAttribute("org.eclipse.jetty.server.Server")

    if (server) {
        // Use reflection to find the thread pool
        def threadPool = server.getConnectors().find { it.class.name.contains("ServerConnector") }?.getExecutor()

        if (threadPool) {
            def maxThreads = threadPool.metaClass.hasProperty(threadPool, "maxThreads") ? threadPool.maxThreads : "Unknown"
            println "Jetty Thread Pool Size: ${maxThreads}"
        } else {
            println "Error: Jetty thread pool not found."
        }
    } else {
        println "Error: Jetty server instance not available in this Jenkins version."
    }
} catch (Exception e) {
    println "Error retrieving Jetty thread pool size: ${e.message}"
}
