1. Enabling Outside insecure access to k8s dashboard
1.1. Remove --auto-generate-certificates from kubernetes-dashboard deployment
1.2. Add --insecure-port=9090
1.3. Change liveness probe scheme to HTTP and set port 9090
1.3. Change kubernetes-dashboard service from ClusterIP to NodePort
1.4. Change target-port and port of the kubernetes-dashboard service from 8443/443 to 9090

2. Now you should be able to connect to the kubernetes-dashboard

Type in the browser - worker_node_external_ip:NodePort (e.g. 192.168.0.20:32619)

Notice: for master node there is a toleration set and kubernetes dashboard pods won't be scheduled, so need to make sure that our worker node was already joined to the k8s cluster
Dashboard arguments link - https://github.com/kubernetes/dashboard/blob/master/docs/common/dashboard-arguments.md