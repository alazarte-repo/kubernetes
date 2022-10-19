resource "digitalocean_kubernetes_cluster" "circle-ci-cluster" {
  name    = "circle-ci-cluster"
  region  = "nyc1"
  version = "1.23.9-do.0"

  node_pool {
    name       = "circle-ci-nodes"
    size       = "s-1vcpu-2gb"
    node_count = 1
    tags = ["circle-ci-nodes"]
  }
}

# More info about Terraform Language: https://www.terraform.io/language