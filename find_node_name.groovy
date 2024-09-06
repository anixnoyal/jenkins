import jenkins.model.*
import hudson.model.*
import java.net.InetAddress

// Define the IP you want to search for
def targetIp = '192.168.1.100'  // Replace with the actual IP you're looking for

// Function to get the IP of the node
def getNodeIP(Computer computer) {
    if (computer.isOffline()) {
        return null
    }
    try {
        def channel = computer.channel
        def inetAddress = channel.call(new Callable<InetAddress, IOException>() {
            public InetAddress call() throws IOException {
                return InetAddress.getLocalHost()
            }
        })
        return inetAddress.getHostAddress()
    } catch (Exception e) {
        return null
    }
}

// Iterate through all Jenkins nodes
def foundNode = null
Jenkins.instance.computers.each { computer ->
    def nodeName = computer.getName()
    def nodeIP = getNodeIP(computer)
    
    if (nodeIP != null && nodeIP == targetIp) {
        foundNode = nodeName
        println "Node with IP $targetIp is: $nodeName"
    }
}

if (foundNode == null) {
    println "No Jenkins node found with IP: $targetIp"
}
