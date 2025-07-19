env:
  - name: JAVA_OPTS
    value: "-Djenkins.model.Jenkins.instance.setRootUrl=https://jenkins.example.com/gts"
  - name: JENKINS_OPTS
    value: "--prefix=/gts"



annotations:
  alb.ingress.kubernetes.io/actions.forward-gts: >
    {"type":"forward","forwardConfig":{"targetGroups":[{"serviceName":"jenkins-gts","servicePort":"80"}]}}
