import java.lang.management.ManagementFactory

def threadMXBean = ManagementFactory.getThreadMXBean()
def allThreads = threadMXBean.dumpAllThreads(false, false)

println "===== Active Thread Pools in Jenkins ====="
allThreads.each { thread ->
    if (thread.threadName.toLowerCase().contains("jetty") || thread.threadName.toLowerCase().contains("pool")) {
        println "Thread: ${thread.threadName} | State: ${thread.threadState}"
    }
}
println "=========================================="
