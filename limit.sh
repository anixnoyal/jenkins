def descriptor = Jenkins.get().getDescriptorByType(
    org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject.DescriptorImpl
)
println(descriptor)


def descriptor = Jenkins.get().getDescriptorByType(
    org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject.DescriptorImpl
)
println(descriptor.metaClass.methods*.name.sort().unique())


import jenkins.model.Jenkins

def descriptor = Jenkins.get().getDescriptorByType(
    org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject.DescriptorImpl
)

def field = descriptor.class.getDeclaredField("concurrentIndexingLimit")
field.setAccessible(true)
field.set(descriptor, 4)

println "Concurrent indexing limit set to: " + field.get(descriptor)
