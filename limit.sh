def descriptor = Jenkins.get().getDescriptorByType(
    org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject.DescriptorImpl
)
println(descriptor)


def descriptor = Jenkins.get().getDescriptorByType(
    org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject.DescriptorImpl
)
println(descriptor.metaClass.methods*.name.sort().unique())

import jenkins.model.Jenkins

Jenkins.get().systemProperties.setProperty("org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject.concurrentIndexingLimit", "4")

println "Concurrent indexing limit set to 4!"
