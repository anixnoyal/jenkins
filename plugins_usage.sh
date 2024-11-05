def pluginUsage = [:]

Jenkins.instance.allItems.each { job ->
    job.getAllActions().each { action ->
        if (action.plugin) {
            def pluginName = action.plugin.displayName
            pluginUsage[pluginName] = pluginUsage.getOrDefault(pluginName, 0) + 1
        }
    }
}

pluginUsage.each { plugin, count ->
    println "Plugin: ${plugin}, Usage Count: ${count}"
}
