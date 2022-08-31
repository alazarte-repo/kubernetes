# Creamos un dominio nuevo

resource "digitalocean_domain" "terraformdomain" {
  name = "adrianlazarte.com"
}

# Add a record to the domain
resource "digitalocean_record" "www" {
  domain = "${digitalocean_domain.terraformdomain.name}"
  type   = "A"
  name   = "adrianlazarte"
  ttl    = "40"
  value  = "${digitalocean_droplet.terraform-test.ipv4_address}"
}

# Posteriormente se valida ejecutando curl -v 143.198.191.70, esto me redirige a la IP del nodo en base al DNI y posteriormente peticiona al puerto del archivo de inicio del contenedor
