env:
  - name: JAVA_OPTS
    value: "-Djenkins.model.Jenkins.instance.setRootUrl=https://jenkins.example.com/gts"
  - name: JENKINS_OPTS
    value: "--prefix=/gts"



kubectl exec -it <jenkins-pod-name> -n <namespace> -- cat /var/jenkins_home/secrets/initialAdminPassword
