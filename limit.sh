System.setProperty("org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject.concurrentIndexingLimit", "4")

println "Concurrent indexing limit set to: " + System.getProperty("org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject.concurrentIndexingLimit")

println System.getProperty("org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject.concurrentIndexingLimit")


-Dorg.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject.concurrentIndexingLimit=100


println "JVM Property: " + System.getProperty("jenkins.scm.events.poolSize")


import java.util.concurrent.Executors
import java.util.concurrent.ThreadPoolExecutor

def executors = [
    "Jenkins Timer Pool": jenkins.util.Timer.get()
]

executors.each { name, executor ->
    if (executor instanceof ThreadPoolExecutor) {
        println "$name → CorePoolSize: ${executor.getCorePoolSize()}, MaxPoolSize: ${executor.getMaximumPoolSize()}"
    } else {
        println "$name → Not a ThreadPoolExecutor, cannot modify."
    }
}

import jenkins.util.Timer
import java.util.concurrent.ScheduledThreadPoolExecutor

ScheduledThreadPoolExecutor executor = (ScheduledThreadPoolExecutor) Timer.get()
executor.setCorePoolSize(100)

println "Temporary: Jenkins Timer Pool thread size set to: " + executor.getCorePoolSize()




import java.util.concurrent.ThreadPoolExecutor
import java.util.concurrent.ScheduledThreadPoolExecutor
import jenkins.util.Timer

def executors = [
    "Jenkins Timer Pool": Timer.get(),
    "Jenkins Queue Executor": jenkins.model.Jenkins.instance.queue.leftItems,
    "Jenkins Overall Thread Pool": java.util.concurrent.Executors.newCachedThreadPool()
]

executors.each { name, executor ->
    if (executor instanceof ThreadPoolExecutor) {
        println "$name → CorePoolSize: ${executor.getCorePoolSize()}, MaxPoolSize: ${executor.getMaximumPoolSize()}"
    } else if (executor instanceof ScheduledThreadPoolExecutor) {
        println "$name → Pool Size: ${executor.getPoolSize()}, Active Threads: ${executor.getActiveCount()}"
    } else {
        println "$name → Not a ThreadPoolExecutor, cannot modify."
    }
}

jenkins.model.Jenkins.instance.setNumExecutors(100)
println "Updated Executor Pool Size to: " + jenkins.model.Jenkins.instance.numExecutors

println "Jenkins Executors: " + jenkins.model.Jenkins.instance.numExecutors
println "Queue Length: " + jenkins.model.Jenkins.instance.queue.items.size()





// Check system properties for any index scan-related settings
println "Jenkins System Properties:"
System.properties.each { key, value ->
    if (key.toLowerCase().contains("index") || key.toLowerCase().contains("scan")) {
        println "$key = $value"
    }
}

// Check Jenkins global configuration for any related settings
println "\nJenkins Global Configuration:"
jenkinsInstance = jenkins.model.Jenkins.instance
jenkinsInstance.globalNodeProperties.each { prop ->
    if (prop.toString().toLowerCase().contains("index") || prop.toString().toLowerCase().contains("scan")) {
        println prop
    }
}

// Check Jenkins environment variables
println "\nJenkins Environment Variables:"
envVars = jenkinsInstance.getGlobalNodeProperties().getAll(hudson.slaves.EnvironmentVariablesNodeProperty)
envVars.each { env ->
    env.envVars.each { key, value ->
        if (key.toLowerCase().contains("index") || key.toLowerCase().contains("scan")) {
            println "$key = $value"
        }
    }
}

// Check system properties at runtime
println "\nJVM Arguments:"
java.lang.management.ManagementFactory.getRuntimeMXBean().getInputArguments().each { arg ->
    if (arg.toLowerCase().contains("index") || arg.toLowerCase().contains("scan")) {
        println arg
    }
}

println "\nScan completed!"



import jenkins.branch.WorkspaceLocator

// Set new pool size
WorkspaceLocator.PoolSize = 10
println "Index scan pool size updated to: ${WorkspaceLocator.PoolSize}"
