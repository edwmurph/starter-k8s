resource "digitalocean_kubernetes_cluster" "k8s-nyc1-01" {
  name    = "k8s-nyc1-01"
  region  = "nyc1"
  version = "1.18.8-do.0" # Latest slug from `doctl kubernetes options versions`

  node_pool {
    name       = "pool-01"
    size       = "s-1vcpu-2gb" # Options from `doctl kubernetes options sizes`
    node_count = 1
  }
}
