https://www.jenkins.io/doc/book/installing/initial-settings/#:~:text=%2D%2DsessionTimeout=$TIMEOUT.%20Sets%20the%20http%20session%20timeout%20value,webapp%20specifies%2C%20and%20then%20to%2060%20minutes



// Output the current session timeout
println("Session timeout is: ${System.getProperty('sessionTimeout')} minutes")


Default Settings: If no session timeout is explicitly configured, servlet containers typically use their default session timeout settings (often 30 minutes).


java -jar jenkins.war --sessionTimeout=60
