System.setProperty("org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject.concurrentIndexingLimit", "4")

println "Concurrent indexing limit set to: " + System.getProperty("org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject.concurrentIndexingLimit")

println System.getProperty("org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject.concurrentIndexingLimit")


-Dorg.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject.concurrentIndexingLimit=100



import io.jenkins.blueocean.events.Pool
import java.util.concurrent.ThreadPoolExecutor

ThreadPoolExecutor executor = (ThreadPoolExecutor) Pool.get()
executor.setCorePoolSize(100)
executor.setMaximumPoolSize(100)

println "SCM Event Thread Pool Size set to: " + executor.getCorePoolSize()
