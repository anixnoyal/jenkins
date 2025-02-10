import jenkins.model.Jenkins

def jenkins = Jenkins.instance

try {
    // Find all executors (this includes Jetty's thread pool if managed by Jenkins)
    def executors = jenkins.servletContext.getAttributeNames().findAll { it.toLowerCase().contains("executor") }

    if (!executors) {
        println "Error: No Jetty-related executors found in this Jenkins instance."
    } else {
        executors.each { name ->
            def executor = jenkins.servletContext.getAttribute(name)
            if (executor?.metaClass.hasProperty(executor, "maxThreads")) {
                println "Jetty Thread Pool Size (from ${name}): ${executor.maxThreads}"
            } else {
                println "Executor '${name}' found but maxThreads property not available."
            }
        }
    }
} catch (Exception e) {
    println "Error retrieving Jetty thread pool size: ${e.message}"
}
