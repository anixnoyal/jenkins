import jenkins.model.Jenkins

def jenkins = Jenkins.instance

try {
    // Attempt to get the Winstone Jetty executor
    def executor = jenkins.servletContext.getAttribute("winstone.Executor")

    if (executor) {
        def maxThreads = executor.metaClass.hasProperty(executor, "maxThreads") ? executor.maxThreads : "Unknown"
        println "Winstone Jetty Thread Pool Size: ${maxThreads}"
    } else {
        println "Error: Could not find Winstone Jetty executor."
    }
} catch (Exception e) {
    println "Error retrieving Winstone Jetty thread pool size: ${e.message}"
}
