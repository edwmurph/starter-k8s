# starter-k8s

Starter for a Kubernetes cluster deployed to Digital Ocean with
 [`kube-prometheus`](https://github.com/prometheus-operator/kube-prometheus)
 plugged in for monitoring/alerting

## Usage

Apply changes to cluster (after completing all below setup):

```
npm run apply
```

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
doctl kubernetes cluster kubeconfig save personal
```

5. Add the following lines to your `/etc/hosts` file:
```
127.0.0.1 monitoring-kube-prometheus-alertmanager.monitoring
127.0.0.1 monitoring-kube-prometheus-prometheus.monitoring
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

### Discord Alerting

The webhook URI to send alerts to must be created in Discord and added to the `slack_api_url` in `prometheus-config.yaml`.

1. Open the server settings in Discord

2. Goto the Integrations tab and click on Webhooks

3. Create a new webhook or select an existing one

4. Copy the Webhook URL and set the value for `slack_api_url` in `prometheus-config.yaml`

5. Add `/slack` to the end of the webhook URI

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

2. Open Alertmanager in your web browser: http://localhost:9093

### Prometheus

1. Forward Prometheus

```
npm run forward prometheus
```

2. Open Prometheus in your web browser: http://localhost:9090

## Upgrading a Helm Chart

### With Helm Operator

1. Set the new version in the `HelmRelease` yaml and apply to the cluster.

2. The Helm Operator should detect an update and upgrade the chart

### Manually

If Helm Operator fails to update the chart, you may update it manually.

1. Update the `HelmRelease` version and apply to the cluster.

2. Issue the update command manually from your local machine, passing in any custom values.

For example, to upgrade the `kube-prometheus-stack` using the `prometheus-config` values:
```
cat kubernetes/prometheus-config.yaml | yq r - 'data."values.yaml"' | helm upgrade -i 9.4.3 -f - prometheus-community/kube-prometheus-stack -n monitoring
```
Don't forget to specify the namespace if other than default!

### Failsafe

If neither of the above methods work, you can delete the `HelmRelease` and recreate it.

1. Update the `HelmRelease` version locally.

2. Delete the remote previous `HelmRelease` definiton from the cluster.

3. Immediately apply the new `HelmRelease` to the cluster.

> PVCs should be preserved and reattached
