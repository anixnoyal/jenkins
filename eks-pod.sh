env:
  - name: JAVA_OPTS
    value: "-Djenkins.model.Jenkins.instance.setRootUrl=https://jenkins.example.com/gts"
  - name: JENKINS_OPTS
    value: "--prefix=/gts"



kubectl exec -it <jenkins-pod-name> -n <namespace> -- cat /var/jenkins_home/secrets/initialAdminPassword


kubectl get secret jenkins -n <namespace> -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode

kubectl get secret jenkins -n <namespace> -o jsonpath="{.data.jenkins-admin-user}" | base64 --decode
