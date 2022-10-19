resource "local_file" "kubernetes_config" {
  content = "${digitalocean_kubernetes_cluster.circle-ci-cluster.kube_config.0.raw_config}"
  filename = "circle-ci-kubeconfig.yaml"
}

resource "circleci_environment_variable" "kubernetes_config" {
  project = "circle-ci-project"
  name = "KUBERNETES_KUBECONFIG"
  value = "${base64encode(digitalocean_kubernetes_cluster.circle-ci-cluster.kube_config.0.raw_config)}"
}

# Una vez creado el proyecto en github y vinculado con circleci, genero en esta ultima plataforma un Token de Acceso (Token de proyecto)
  # Se llama token-to-terraform y su valor es 3aa85ff91d1c048869c18d99014893afc3442e17 (var.circleci_token)
  # personal-token-to-terraform 34fa1f8a04fef60348b35b1748c1fcea95eb7f6a (provider.circleci.token)
  # provider.circleci.organization: dislepsia
  
# El siguiente paso es crear una API Token en DO:
  # En nuestro caso es integration-project-token: dop_v1_afe2b044f85d83ae3447c111d8599b2751b89c5fb2fdeb005b111ce3bb69ac53 (var.digitalocean_token)