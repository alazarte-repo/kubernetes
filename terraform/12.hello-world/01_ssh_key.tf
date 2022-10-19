# https://www.youtube.com/watch?v=1itPqkU8XZw
# Exportamos nuestra key SSH

resource "digitalocean_ssh_key" "terraform" {
  name       = "terraform"
  public_key = file("id_rsa.pub")
}

# .\terraform plan nos dira qué hara el proveedor pero no ejecutara nada

# .\terraform apply aplica los cambios
# Aclaraciones:
  # Sera necesario crear un API Token en Digital Ocean para que, al correr .\terraform apply, lo ingresemos, 
  # de esta forma validara con el proveedor de servicios y continuara el proceso de creación de la ssh key
  # Al crearse el token, éste, solo se muestra una vez por lo que lo dejo acá: dop_v1_ecae0b761afddff4ee6dbcff4f8b35094bf5becb54528c008eeb41ad405c44a1
  
  # El archivo id_rsa.pub tiene el copy-paste de la clave ssh generada en puttygen tal y como se ve en el label