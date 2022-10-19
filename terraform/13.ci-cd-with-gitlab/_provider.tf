variable "digitalocean_token" {} # Declara una variable

terraform {
  required_version = ">= 0.14.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.digitalocean_token
}

# Terraform es una tecnología que me permite declarar una infraestructura como código.
# Como funciona? Se conecta a la api de un proveedor y se encarga de mantener lo que vos tenes en el código en el proveedor. Lo que me abstrae lidiar con la interfaz gráfica

# Las variables de entorno de Terraform deben empezar con TF_VAR_Nombre

# Para traer la configuración de nuestro proveedor debemos ejecutar ".\terraform init", para ello es necesario tener el ejecutable dentro del directorio.
# Otro factor importante es que para llevar la ejecución del comando anterior, sera necesario disponer en el directorio SÓLO del archivo _provider.tf, posteriormente en la medida que se ejecute el resto de la infra se deberan sumar el resto de los archivos.

# El archivo userdata.yaml tienen muchas más opciones, como correr contenedores, administrar usuarios ssh, etc. supuestamente podriamos crear todo lo que nos ofrece cualquier proveedor.