import jenkins.scm.api.SCMEvent

println "Forcefully clearing stuck SCM events..."
SCMEvent.events.each { event ->
    println "Forcing event cleanup: ${event.class.name} - ${event.state}"
    event.complete()  // Tries to mark event as complete
}
SCMEvent.events.clear()
println "SCM event queue forcefully cleared."
