import jenkins.model.Jenkins

def jenkins = Jenkins.instance

try {
    // Attempt to retrieve the Jetty Server instance dynamically
    def server = jenkins.servletContext.getAttribute("org.eclipse.jetty.server.Server")

    if (server == null) {
        println "Error: Unable to access Jetty server instance. It may not be available in this Jenkins version."
    } else {
        // Find the Jetty thread pool dynamically
        def threadPool = server.getBeans().find { it.class.name.toLowerCase().contains("queuedthreadpool") }

        if (threadPool) {
            def maxThreads = threadPool.getMaxThreads()
            println "Jetty Thread Pool Size: ${maxThreads}"
        } else {
            println "Error: Could not retrieve Jetty thread pool settings."
        }
    }
} catch (Exception e) {
    println "Error retrieving Jetty thread pool size: ${e.message}"
}
