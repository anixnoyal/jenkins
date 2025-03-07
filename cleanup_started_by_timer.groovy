// import jenkins.model.*
// import hudson.model.*
// import hudson.triggers.TimerTrigger

// def jenkins = Jenkins.instance
// def queue = jenkins.queue
// def currentTime = System.currentTimeMillis()

// queue.items.each { item ->
//     def causes = item.getCauses()

//     // Check if the item was started by a timer
//     def isTimerTriggered = causes.any { it instanceof TimerTrigger.TimerTriggerCause }
    
//     if (isTimerTriggered) {
//         def waitTimeInSeconds = (currentTime - item.inQueueSince) / 1000 // Convert ms to sec
        
//         if (waitTimeInSeconds > 60) {
//             println "Removing job: '${item.task.name}' (Waiting: ${waitTimeInSeconds} sec, Started by Timer)"
//             queue.cancel(item)
//         }
//     }
// }


import jenkins.model.*
import hudson.model.*
import hudson.triggers.TimerTrigger

def jenkins = Jenkins.instance
def queue = jenkins.queue
def currentTime = System.currentTimeMillis()

queue.items.each { item ->
    def causes = item.getCauses()
    def isTimerTriggered = causes.any { it instanceof TimerTrigger.TimerTriggerCause }

    if (isTimerTriggered) {
        def waitTimeInSeconds = (currentTime - item.inQueueSince) / 1000 // Convert ms to sec
        def isWaitingForNode = item.isStuck() // True if it's waiting for an available node

        if (isWaitingForNode && waitTimeInSeconds > 300) {
            println "Removing job: '${item.task.name}' (Waiting: ${waitTimeInSeconds} sec, Waiting for node: Yes, Started by Timer)"
            queue.cancel(item)
        }
    }
}
