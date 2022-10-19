resource "local_file" "kubernetes_config" {
  content = "${digitalocean_kubernetes_cluster.terraform-cluster.kube_config.0.raw_config}"
  filename = "kubeconfig.yaml"
}
# Esto me genera un kubeconfig en el directorio donde estoy parado para que pueda controlar mi cluster de kubectl desde nuestro ordenador