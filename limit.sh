def descriptor = Jenkins.get().getDescriptorByType(
    org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject.DescriptorImpl
)
println(descriptor)
