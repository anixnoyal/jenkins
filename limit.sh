import jenkins.scm.api.SCMEventIndexer

println "Current Index Scan Pool Size: " + SCMEventIndexer.class.getDeclaredField("poolSize").get(null)
