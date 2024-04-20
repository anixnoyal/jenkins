openssl pkcs12 -export -out your_domain.p12 -inkey private.key -in your_domain.crt -certfile DigiCertCA.crt
keytool -importkeystore -destkeystore your_keystore.jks -srckeystore your_domain.p12 -srcstoretype PKCS12 -deststoretype JKS
keytool -list -keystore your_keystore.jks
