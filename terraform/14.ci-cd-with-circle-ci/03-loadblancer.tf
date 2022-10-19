resource "digitalocean_loadbalancer" "public" {
  name = "loadbalancer-1"
  region = "nyc1"

  forwarding_rule {
    entry_port = 80 # Puerto del contenedor/pod
    entry_protocol = "http"

    target_port = 30020 # Puerto del balanceador
    target_protocol = "http"
  }

  healthcheck {
    port = 30020
    protocol = "tcp"
  }

  droplet_tag = "circle-ci-nodes"
}