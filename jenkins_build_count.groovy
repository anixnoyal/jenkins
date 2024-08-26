import jenkins.model.Jenkins
import hudson.model.Queue

def maxConcurrency = 0
def minConcurrency = Integer.MAX_VALUE
def totalConcurrency = 0
def sampleCount = 0

def jenkins = Jenkins.instance
def computerList = jenkins.computers

def getRunningBuilds() {
    def count = 0
    computerList.each { computer ->
        count += computer.builds.size()
    }
    return count
}

for (int i = 0; i < 100; i++) { // Sample 100 times (adjust as needed)
    def runningBuilds = getRunningBuilds()
    maxConcurrency = Math.max(maxConcurrency, runningBuilds)
    minConcurrency = Math.min(minConcurrency, runningBuilds)
    totalConcurrency += runningBuilds
    sampleCount++
    Thread.sleep(1000) // Wait 1 second between samples (adjust as needed)
}

def avgConcurrency = sampleCount > 0 ? totalConcurrency / sampleCount : 0

println "Min concurrent builds: $minConcurrency"
println "Avg concurrent builds: $avgConcurrency"
println "Max concurrent builds: $maxConcurrency"
