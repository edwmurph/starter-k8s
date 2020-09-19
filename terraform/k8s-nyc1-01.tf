resource "digitalocean_kubernetes_cluster" "personal" {
  name    = "personal"
  region  = "nyc1"
  version = "1.18.8-do.0" # Latest slug from `doctl kubernetes options versions`

  node_pool {
    name       = "default-pool"
    size       = "s-1vcpu-2gb" # Options from `doctl kubernetes options sizes`
    node_count = 1
    auto_scale = true
    min_nodes = 1
    max_nodes = 2
  }
}
