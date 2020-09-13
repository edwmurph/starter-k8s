# starter-k8s

my starter for a k8s cluster

## Dev setup

1. Install `kubectl` within one minor version of k8s cluster
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
5. Login docker to the DO registry:
```
doctl registry login
```
