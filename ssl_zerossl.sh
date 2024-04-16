
openssl pkcs12 -export -in certificate.crt -inkey private.key -certfile ca_bundle.crt -out keystore.p12 -name jenkins -password pass:anixnoyal

keytool -importkeystore \
        -srckeystore keystore.p12 \
        -srcstoretype PKCS12 \
        -srcstorepass anixnoyal \
        -destkeystore jenkins.jks \
        -deststoretype JKS \
        -deststorepass anixnoyal \
        -destkeypass anixnoyal 

cp jenkins.jks /var/cache/jenkins/

