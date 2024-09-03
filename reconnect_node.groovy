// Import necessary classes
import jenkins.model.*
import hudson.model.*

// Get the Jenkins instance
def jenkins = Jenkins.getInstance()

// Loop through all nodes
jenkins.nodes.each { node ->
    // Check if node is online
    if (node.getComputer().isOnline()) {
        println "Node ${node.getNodeName()} is online."
    } else {
        println "Node ${node.getNodeName()} is offline. Attempting to reconnect..."
        // Attempt to reconnect
        node.getComputer().connect(false)
        // Optional: Print the result of the reconnection attempt
        println "Reconnection attempt for node ${node.getNodeName()} done."
    }
}
