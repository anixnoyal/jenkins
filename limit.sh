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
