# Kubernetes commands to run cluster

## Create cluster

I used this command to create a cluster with the loadbalancer open on host port 8081

```bash
k3d cluster create --port 8082:30080@agent:0 -p 8081:80@loadbalancer --agents 2
```

## Install ArgoCD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f <https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml>
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

## get ArgoCD credentials

```bash
kubectl get -n argocd secrets argocd-initial-admin-secret -o yaml
TODO - get sample port forward command
```

## Install NATS

Please install on default namespace

```bash
kubens default
helm repo add nats https://nats-io.github.io/k8s/helm/charts/
helm install --namespace=default nats nats/nats
```

## Install Argo Rollouts

The deployments are currently Deployments not Rollouts, but the config is there for both

```bash
kubectl create namespace argo-rollouts
kubectl apply -n argo-rollouts -f <https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml>
```

## Install NGINX load balancer

helm upgrade --install ingress-nginx ingress-nginx \
  --repo <https://kubernetes.github.io/ingress-nginx> \
  --namespace ingress-nginx --create-namespace

helm repo add ingress-nginx <https://kubernetes.github.io/ingress-nginx>
helm repo update
helm install nginx-ingress ingress-nginx/ingress-nginx

## Install Linkerd

## Building with Kustomize

```bash
kustomize build manifests/overlays/production | kubectl apply -f -
```
