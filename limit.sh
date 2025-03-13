def descriptor = Jenkins.get().getDescriptorByType(
    org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject.DescriptorImpl
)
println(descriptor)


def descriptor = Jenkins.get().getDescriptorByType(
    org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject.DescriptorImpl
)
println(descriptor.metaClass.methods*.name.sort().unique())
