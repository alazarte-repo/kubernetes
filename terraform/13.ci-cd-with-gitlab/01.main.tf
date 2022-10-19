resource "digitalocean_kubernetes_cluster" "terraform-cluster" {
  name    = "terraform-cluster"
  region  = "ams3"
  version = "1.23.10-do.0"

  node_pool {
    name       = "terraform-nodes"
    size       = "s-1vcpu-2gb"
    node_count = 1
  }
}


# La infraestructura para llevar a cabo la CI/CD es la creación de un cluster de kubernetes junto a 2 nodos.
# Posteriormente generar un kubeconfig.yaml como output de esta configuración y usarlo para levantarlo de forma local
# Como ultimo paso sera crear un nuevo droplet para gitlab utilizando la ssh, añadiendo un dominio y configurando el server

# Fue necesario crear un token de acceso en digital ocean, para ello generamos el siguiente par <clave, valor>:
 # <digitalocean_token, dop_v1_442a9850fc461f8cb885b7f087932a120a88604be0a08c716f18e3833ce12739>