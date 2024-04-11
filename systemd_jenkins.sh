[Service]
Environment="JAVA_OPTS=-Xmx1024m"
Environment="JAVA_OPTS=${JAVA_OPTS} -Djava.awt.headless=true"
Environment="JAVA_OPTS=${JAVA_OPTS} -Djenkins.install.runSetupWizard=false"
