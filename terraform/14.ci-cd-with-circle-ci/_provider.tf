variable "digitalocean_token" {}

variable "circleci_token" {}

terraform {
  required_version = ">= 0.14.0"

  required_providers { # Check this: Argument definitions must be separated by newlines, not commas. An argument definition must end with a newline.
    digitalocean = {
      source  = "digitalocean/digitalocean"
    }

    circleci = { 
      source = "TomTucka/circleci"
      version = "0.2.0"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "${var.digitalocean_token}"
}

# Para traer la configuración de nuestro proveedor debemos ejecutar ".\terraform init"

# .\terraform apply aplica los cambios
# Aclaraciones:
  # Sera necesario crear un API Token en Digital Ocean para que, al correr .\terraform apply, lo ingresemos, 
  # de esta forma validara con el proveedor de servicios y continuara el proceso de creación de la ssh key
  # Al crearse el token, éste, solo se muestra una vez por lo que lo dejo acá: dop_v1_ecae0b761afddff4ee6dbcff4f8b35094bf5becb54528c008eeb41ad405c44a1
  