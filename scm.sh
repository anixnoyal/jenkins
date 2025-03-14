import jenkins.scm.api.SCMEventQueue

SCMEventQueue.get().with {
    setMaxConcurrent(20)  // Increase to 20 threads
}
println "SCM event limit increased to: " + SCMEventQueue.get().maxConcurrent
