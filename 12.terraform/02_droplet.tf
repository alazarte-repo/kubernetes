# Creamos el droplet

resource "digitalocean_droplet" "terraform-test" {
  image     = "ubuntu-18-04-x64"
  name      = "terraform-test-1"
  region    = "nyc1"
  size      = "s-1vcpu-1gb"
  user_data = file("userdata.yaml")
  ssh_keys  = ["${digitalocean_ssh_key.terraform.fingerprint}"]
}
