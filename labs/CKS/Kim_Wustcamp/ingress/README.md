1. After terraform provision, join worker node
on master node - kubeadm token create --print-join-command --ttl 0
2. Run output on worker node.
3. In this lab we need to create ingress object but ingress controller ValidationWebhook prevents it,
to workaround it, we can:
3.1. Delete ingress controller ValidationWebhook
sudo kubectl delete ValidatingWebhookConfiguration ingress-nginx-admission
3.2. Install ingress-controller as a helm chart and in this case we'll be able to create ingress resource
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
3.3. Update versions in ValidationWebhook config 
https://stackoverflow.com/questions/69167854/kubernetes-ingress-nginx-controller-internal-error-occurred-failed-calling-web

4. Verification
curl https://secure-ingress.com:32280/service2 -kv --resolve secure-ingress.com:32280:34.168.110.14
curl https://secure-ingress.com:32280/service1 -kv --resolve secure-ingress.com:32280:34.168.110.14

32280 - nodeport of ingress-nginx-controller (https port)
34.168.110.14 - external ip of worker node
secure-ingress.com - CN we're using for our TLS cert
--resolve - instead of adding /etc/hosts string with secure-ingress.com, we can specify this option to check how ingress will work with TLS certs that we've created before