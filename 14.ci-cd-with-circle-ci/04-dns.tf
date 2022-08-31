# Creamos un dominio nuevo

resource "digitalocean_domain" "circlecidomain" {
  name = "circlecidomain.com"
}

# Add a record to the domain
resource "digitalocean_record" "circlecirule" {
  domain = "${digitalocean_domain.circlecidomain.name}"
  type   = "A"
  name   = "test"
  ttl    = "50"
  value  = "${digitalocean_loadbalancer.public.ip}"
}

