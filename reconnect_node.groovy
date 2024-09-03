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


// Define the name of the node you want to reconnect
def nodeName = "<node_name>"

// Get the Jenkins instance
def jenkins = Jenkins.getInstance()

// Get the specified node by name
def node = jenkins.getNode(nodeName)

if (node != null) {
    // Check if the node's computer is offline
    def computer = node.getComputer()
    if (computer.isOnline()) {
        println "Node '${nodeName}' is already online."
    } else {
        println "Node '${nodeName}' is offline. Attempting to reconnect..."
        try {
            // Attempt to reconnect the node
            computer.connect(false)
            println "Reconnection attempt for node '${nodeName}' done."
        } catch (Exception e) {
            println "Failed to reconnect node '${nodeName}': ${e.message}"
        }
    }
} else {
    println "Node '${nodeName}' not found."
}
