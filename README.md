# starter-k8s

Starter for a Kubernetes cluster deployed to Digital Ocean with
 [`kube-prometheus`](https://github.com/prometheus-operator/kube-prometheus)
 plugged in for monitoring/alerting

## Terraform setup

1. Manually create DO space/bucket for terraform state specified in [s3 terraform backend](./terraform/versions.tf)

1. Export tokens to env:
  - `DIGITALOCEAN_ACCESS_TOKEN`: do personal access token
  - `AWS_ACCESS_KEY_ID`: do spaces access key id for tf state backend
  - `AWS_SECRET_ACCESS_KEY`: do spaces secret access key for tf state backend
  - `SPACES_ACCESS_KEY_ID`: do spaces access key id for managing do spaces
  - `SPACES_SECRET_ACCESS_KEY`: do spaces secret access key for managing do spaces

3. Install terraform to exact version used by terraform code

4. Init terraform state
```
terraform init terraform
```

5. Provision k8s cluster
```
terraform apply terraform
```

## K8s setup


1. Install `kubectl` within one minor version of k8s cluster
https://kubernetes.io/docs/tasks/tools/install-kubectl/

2. Install `doctl`

3. Authenticate DO CLI with `personal` context:

```
doctl auth init --context personal
doctl auth switch --context personal
```

4. Pull cluster configuration:
```
doctl kubernetes cluster kubeconfig save k8s-nyc1-01
```

## Helm Setup

To bootstrap the cluster we need to install Helm Operator:
https://github.com/fluxcd/helm-operator/blob/master/chart/helm-operator/README.md

1. Install `Helm` 3.x cli:

```
brew install helm
```

2. Add Flux CD Helm repo:

```
helm repo add fluxcd https://charts.fluxcd.io
```

3. Identify the desired version:
https://github.com/fluxcd/helm-operator/releases

4. Install the `HelmRelease` Custom Resource Definition:

```
kubectl apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/{{ version }}/deploy/crds.yaml
```

5. Create the `flux` namespace:

```
kubectl create namespace flux
```

6. Install the Helm Operator for 3.x on the cluster:

```
helm upgrade -f config/helm-operator.yaml \
	-i helm-operator fluxcd/helm-operator \
  --namespace flux \
  --set helm.versions=v3
```

7. Create the `monitoring` namespace:

```
kubectl create namespace monitoring
```

## Service Forwarding

To connect to internal-only services, forward the port to your local machine.

### Grafana

1. Forward Grafana

```
npm run forward grafana
```

2. Open Grafana in your web browser: http://localhost:3000

3. Login:

```
Username: admin
Password: poleax-lay-levitate
```

### AlertManager

1. Forward AlertManager

```
npm run forward alertmanager
```

2. Open Alertmanager in your web browser: http://localhost:3000

### Prometheus

1. Forward Prometheus

```
npm run forward prometheus
```

2. Open Prometheus in your web browser: http://localhost:3000
