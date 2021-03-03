# starter-k8s

Starter for a Kubernetes cluster deployed to Digital Ocean with
 [`kube-prometheus`](https://github.com/prometheus-operator/kube-prometheus)
 plugged in for monitoring/alerting

## Usage

Apply changes to cluster (after completing all below setup steps):

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

## Dev setup


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

## Cluster Setup

### Namespaces
1. Create the namespaces:
```
kubectl apply -f kubernetes/namespaces.yaml
```

### Flux
To bootstrap the cluster we need to install Flux:
https://toolkit.fluxcd.io/guides/installation/

1. Install the Flux CLI:
```
brew install fluxcd/tap/flux
```

2. Generate a Github Personal Access token with private repo access

3. Bootstrap Flux
```
GITHUB_TOKEN=<your token from prev step> flux bootstrap github \
  --owner=<github username> \
  --repository=<github repo name> \
  --branch=master \
  --components=source-controller,kustomize-controller,helm-controller,notification-controller \
  --path=clusters/personal
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
