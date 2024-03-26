# jenkins k8 plugin 
kubectl create namespace jenkins
kubectl create serviceaccount jenkins --namespace=jenkins
kubectl describe serviceaccount jenkins --namespace=jenkins | grep Token | awk '{print $2}'
kubectl describe secret jenkins-token-zw45p --namespace=jenkins
kubectl create rolebinding jenkins-admin-binding --clusterrole=admin --serviceaccount=jenkins:jenkins --namespace=jenkins
