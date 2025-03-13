import jenkins.scm.api.SCMEventIndexer

println "Current Index Scan Pool Size: " + SCMEventIndexer.class.getDeclaredField("poolSize").get(null)

-Djenkins.scm.api.SCMEventIndexer.poolSize=10

System.properties.each { key, value ->
    if (key.toLowerCase().contains("scm") || key.toLowerCase().contains("index")) {
        println "$key = $value"
    }
}
