#-Djenkins.executor.count=0 -Dwinstone.maxThreads=0


import jenkins.model.Jenkins

def jenkins = Jenkins.instance

try {
    // Print all servlet attributes to find Jetty-related executors
    def context = jenkins.servletContext
    println "===== Available Servlet Context Attributes ====="
    context.getAttributeNames().each { name ->
        println "Attribute: ${name} -> ${context.getAttribute(name)?.getClass()?.getName()}"
    }
    println "============================================="

    // Attempt to find an attribute related to Winstone or Jetty executors
    def possibleExecutors = context.getAttributeNames().findAll { it.toLowerCase().contains("executor") || it.toLowerCase().contains("threadpool") }

    if (!possibleExecutors) {
        println "Error: No thread pool or executor-related attributes found."
    } else {
        possibleExecutors.each { name ->
            def executor = context.getAttribute(name)
            if (executor?.metaClass.hasProperty(executor, "maxThreads")) {
                println "Jetty/Winstone Thread Pool Size (from ${name}): ${executor.maxThreads}"
            } else {
                println "Executor '${name}' found but does not expose 'maxThreads'."
            }
        }
    }
} catch (Exception e) {
    println "Error retrieving Winstone Jetty thread pool size: ${e.message}"
}
