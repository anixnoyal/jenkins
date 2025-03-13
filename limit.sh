println(Jenkins.instance.getDescriptorByType(
    org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject.DescriptorImpl
).getConcurrentIndexingLimit())
