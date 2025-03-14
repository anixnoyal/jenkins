<settings>
    <proxies>
        <!-- HTTP Proxy -->
        <proxy>
            <id>http-proxy</id>
            <active>true</active>
            <protocol>http</protocol>
            <host>proxy.example.com</host>
            <port>8080</port>
            <nonProxyHosts>localhost|127.0.0.1|*.mycompany.com</nonProxyHosts>
        </proxy>

        <!-- HTTPS Proxy -->
        <proxy>
            <id>https-proxy</id>
            <active>true</active>
            <protocol>https</protocol>
            <host>secureproxy.example.com</host>
            <port>8443</port>
            <nonProxyHosts>localhost|127.0.0.1|*.mycompany.com</nonProxyHosts>
        </proxy>
    </proxies>
</settings>


#export JAVA_OPTS="$JAVA_OPTS -Djenkins.scm.api.SCMEvent.EVENT_THREAD_POOL_SIZE=100"

import jenkins.util.SystemProperties

SystemProperties.setInteger("jenkins.scm.api.SCMEvent.EVENT_THREAD_POOL_SIZE", 100)

println "Temporary EVENT_THREAD_POOL_SIZE set to: " + SystemProperties.getInteger("jenkins.scm.api.SCMEvent.EVENT_THREAD_POOL_SIZE", 10)

