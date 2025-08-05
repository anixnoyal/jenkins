import jenkins.util.Timer

def timer = Timer.get()
println "Core pool size: ${timer.corePoolSize}"
println "Active threads: ${timer.activeCount}"
