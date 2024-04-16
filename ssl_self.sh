openssl req -x509 -newkey rsa:4096 -keyout jenkins.key -out jenkins.crt -days 365 -subj "/CN=jenkins.sreguru.in" -nodes
openssl pkcs12 -export -in jenkins.crt -inkey jenkins.key -out jenkins.p12 -name jenkins -passout pass:anixnoyal
keytool -importkeystore -srckeystore jenkins.p12 -srcstoretype pkcs12 -destkeystore jenkins.jks -deststoretype jks -srcstorepass anixnoyal -deststorepass anixnoyal -srcalias jenkins -destalias jenkins -noprompt
java  -jar agent.jar -url https://192.168.31.211:8443/ -secret 434aac7823a1ce17830362ba2ff4c26c1bed55979d454147976bb2a41feadd4e -name localpc -workDir "/tmp/localpc" -noCertificateCheck -webSocket
