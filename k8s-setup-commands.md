# Kubernetes commands to run cluster

I've documented the various commands required to get this cluster up and running in a local environment using k3d.

## Requirements

- Docker
- Kubernetes CLI (kubectl)
- K9s (optional but highly recommended)

## Create cluster

I used this command to create a cluster with the loadbalancer open on host port 8081. 

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

The default username is `admin`. You can find the default base64 encoded password with the command below.

```bash
kubectl get -n argocd secrets argocd-initial-admin-secret -o yaml

# copy the password field and execute the following:
echo "<password>" | base64 -d

kubectl port-forward svc/argocd-server -n argocd 8800:443 # chosen at random to avoid conflicts

```

## Install NATS

Please install on default namespace

```bash
kubens default
helm repo add nats https://nats-io.github.io/k8s/helm/charts/
helm install --namespace=default nats nats/nats
```

## Install Argo Rollouts

The deployments are currently Kubernetes native Deployments not Rollouts, but the config is there for both

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

## Building and deploying with Kustomize

To build and deploy without using ArgoCD, you can build the project with customize and pipe the output into kubectl. If you don't have Kustomize installed, use the kubectl version of the command below.

```bash
kustomize build manifests/overlays/production | kubectl apply -f -
kustomize build manifests/overlays/staging | kubectl apply -f -

# or

kubectl apply -k # check this
```

## Tearing down the deployments

Use the command that mirrors the one you created the deployments with.

```bash
kustomize build manifests/overlays/production | kubectl delete -f -
kustomize build manifests/overlays/staging | kubectl delete -f -
```
