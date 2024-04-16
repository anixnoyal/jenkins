#need plugins 
configuration-as-code
performance


#list of plugins
Jenkins.instance.pluginManager.plugins.each {
   println("${it.getShortName()}: ${it.getVersion()}")
}
