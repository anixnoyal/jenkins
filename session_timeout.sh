Environment="JAVA_OPTS=-DsessionTimeout=60

// Output the current session timeout
println("Session timeout is: ${System.getProperty('sessionTimeout')} minutes")


Default Settings: If no session timeout is explicitly configured, servlet containers typically use their default session timeout settings (often 30 minutes).


java -jar jenkins.war --sessionTimeout=60
