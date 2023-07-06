Access jenkins after terraform provisioning

According to the configuration you should access K8s cluster from your local machine.
First we need to check creds
User - kubectl get secret jenkins -o jsonpath='{.data.jenkins-admin-user}' -n jenkins |base64 -d
Password - kubectl get secret jenkins -o jsonpath='{.data.jenkins-admin-password}' -n jenkins |base64 -d
Then you can access jenkins via service or via Pod

Via service
kubectl port-forward svc/jenkins 8080:8080 -n jenkins
Open your browser localhost:8080 and you should see jenkins login screen


Via POD
1) Place POD_NAME in a variable for easier futher use
export POD_NAME=$(kubectl get pod -l app.kubernetes.io/component=jenkins-controller -n jenkins -o jsonpath="{.items[*].metadata.name}")

2) Expose port to access remotely deployed Jenkins from your local machine
kubectl port-forward $POD_NAME 8081:8080 -n jenkins >> /dev/null 2>&1 &