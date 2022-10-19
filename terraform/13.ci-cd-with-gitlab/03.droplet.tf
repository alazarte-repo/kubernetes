# Exportamos nuestra key SSH

resource "digitalocean_ssh_key" "gitlab_ssh_key" {
  name       = "gitlab_ssh_key"
  public_key = file("id_rsa.pub")
}

# Creamos el droplet

resource "digitalocean_droplet" "gitlab" {
  image     = "ubuntu-18-04-x64"
  name      = "gitlab-1"
  region    = "nyc1"
  size      = "s-4vcpu-8gb"
  user_data = file("userdata.yaml")
  ssh_keys  = ["${digitalocean_ssh_key.gitlab_ssh_key.fingerprint}"]
}

resource "digitalocean_domain" "terraformdomain" {
  name = "terraformgit.com"
}

# Add a record to the domain
resource "digitalocean_record" "git" {
  domain = "${digitalocean_domain.terraformdomain.name}"
  type   = "A"
  name   = "git"
  value  = "${digitalocean_droplet.gitlab.ipv4_address}"
}

# Posteriormente a la creación del droplet, es necesario entrar al server para resetear la contraseña del root. 
# Para ello solicitaremos una password temporal (9986cbf994d17971e3482f32a2) que llega a través del correo y que se solicita en la pestaña "Access" botón "Reset root password" dentro del droplet.

# Al entrar insertamos la clave temporal y creamos una nueva: gitlab_key

# Es necesario entrar al droplet y luego al contenedor para setear las credenciales de git para ello ejecutamos la consola del usuario root:
# Entramos al droplet a través del siguiente comando: ssh root@143.198.175.40

  # Accedemos al contenedor:
    # docker ps
    # docker exec -it 2a0fb7c2d46e bash
    # Dentro del contenedor reseteamos/seteamos la password para acceder al gitlab
    # Una vez dentro del contenedor ejecutamos el siguiente comando para acceder al server de GitLab: gitlab-rails console production (Aclaración: Quizás al entrar como root no sea necesario colocar el parametro 'production')
      #  u = User.where(id:1).first
      #  u.password = 'gitlab_key'
      #  u.password_confirmation = 'gitlab_key'
      #  u.save!
      #  exit

    # Fuente: https://cm-gitlab.stanford.edu/help/security/reset_root_password.md

# Salimos del contenedor y del droplet, nos vamos a gitlab (Ip del nodo) y nos logueamos <root, gitlab_key>

# Debemos crear un grupo y luego un proyecto para que recién dentro del proyecto nos aparezca la opción de "Crear clúster de kubernetes"
  # El grupo se llama integration-group
  # El proyecto se llama integration-project

# Pasos para crear la vinculación/integración entre Kubernetes y GitLab
  # Por defecto la CI/CD de un proyecto esta habilitado pero sino debemos seguir el siguiente instructivo: http://165.227.199.38/help/ci/enable_or_disable_ci.md#enable-cicd-in-a-project
  # El siguiente paso es generar un agente de configuración, parecería ser un token de acceso que permite la vinculación entre ambas plataformas. http://165.227.199.38/help/user/clusters/agent/install/index#register-the-agent-with-gitlab
    # El mismo debe estar en el siguiente directorio dentro del repo: .gitlab/agents/k8s-agent/config.yaml
    
    #    Agregamos el contenido al archivo config.yaml:
    #      gitops:
    #      manifest-projects:
    #      -   id: integration-group/integration-project
    #          default_namespace: default
    #      ci_access:
    #          groups:
    #          -   id: integration-group

    # Fuente: https://docs.gitlab.com/ee/user/clusters/agent/gitops.html

  # Posteriormente vamos al menú Infraestructure->Kubernetes Cluster->Connect to cluster y seleccionamos el agente previamente creado.
    # El token asignado es: KceLS5-34sQrxMWkiAPctNqCbwFvFtWtnK_E1ad6dzsrKzykxg
    
  # Además, entramos al droplet como root (recordemos de resetear y cambiar la contraseña) y corremos los siguientes comandos para instalar Helm y posteriormente conectar con el cluster:

    # La clave del usuario root es: terraform

      #helm repo add gitlab https://charts.gitlab.io
      #helm repo update
      # Copiamos el contenido del archivo kubeconfig.yaml generado por el 02.output.yaml al nodo en cuestión, guardamos y luego seteamos la variable de entorno con el path hacia este archivo.
        # export KUBECONFIG=kubeconfig.yaml 
      #helm upgrade --install k8s-agent gitlab/gitlab-agent --namespace gitlab-agent --create-namespace --set image.tag=v15.3.0 --set config.token=KceLS5-34sQrxMWkiAPctNqCbwFvFtWtnK_E1ad6dzsrKzykxg --set config.kasAddress=ws://143.198.175.40//-/kubernetes-agent/

Una vez linkeado el cluster de kubernetes con el dropplet de gitlab voy a GitLab, puntualmente a la parte de opciones de grupo -> CI/CD->Runners (Token: GR1348941eLCpreJ9jc99TktXhonN)
Instalamos Runners de gitlab en el cluster de terraform donde ya esta cargado el kubeconfig
# Download the binary for your system
sudo curl -L --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64

# Give it permission to execute
sudo chmod +x /usr/local/bin/gitlab-runner

# Create a GitLab Runner user
sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash

# Install and run as a service
sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
sudo gitlab-runner start

Registramos el runner
sudo gitlab-runner register --url http://git.terraformgit.com/ --registration-token GR1348941eLCpreJ9jc99TktXhonN
Luego nos preguntara algunos datos del runner (Entre ellos el TAG y alli seteamos los proyectos a los que queremos que el runner este ligado) y finalmente obtendremos este mensaje: 
  Configuration (with the authentication token) was saved in "/etc/gitlab-runner/config.toml" 

Posteriormente seteamos el runner en el grupo
curl --request POST --header "PRIVATE-TOKEN: GR1348941StHnLyvaeUmW8bA5bJRz" "http://143.198.175.40/groups/integration-group/-/runners/1" --form "runner_id=1"

Es necesario entrar al archivo de configuraciónd del runner instalado en el cluster de kubernetes y hacer las siguientes modificaciones:
eliminar la linea host
cambiar el namespace por el nombre donde se encuentre instalado lo de gitlab

Fuente: http://143.198.175.40/help/api/runners.md

Runner Configuration: http://143.198.175.40/groups/integration-group/-/runners/1/edit



Para que sirve esto?: De esta forma, gitlab se conecta a nuestro cluster de kubernetes (terraform-cluster) para llevar a cabo la ejecución de los jobs,
de esta forma no sobrecargamos al servidor donde esta gitlab, que quizás tenga demasiados jobs y hace que funcione lento

# Fuentes:
# https://www.youtube.com/watch?v=NgNoTVL9PRw
# https://www.youtube.com/watch?v=e1S2xpb_zKU

#CI con Digital Ocean
#
#A. Digital Ocean tiene un contenedor privado de contenedores (Similar a DockerHub)
#
#1. Para utilizarlo es necesario ir al menú "Container Register" y crear uno repositorio de imagen para un proyecto
#2. El siguiente paso es crear una API Token:
#  En nuestro caso es integration-project-token: dop_v1_afe2b044f85d83ae3447c111d8599b2751b89c5fb2fdeb005b111ce3bb69ac53
#3. Luego, debo abrir una terminal y loguearme a través de los siguientes comandos:
#  docker login registry.digitalocean.com
#  Username: integration-project-token
#  Password: integration-project-token
#4. Posteriormente debo generar una imagen desde el dockerfile
#  docker build sfintegracionapi:1.0 .
#5. Tagueamos una imagen nueva
#   docker tag sfintegracionapi:1.0 registry.digitalocean.com/integration-project/sfintegracionapi:1.0
#6. Subimos al repo de contenedores:
#  docker push registry.digitalocean.com/integration-project/sfintegracionapi:1.0
#7. Creo un projecto en GitHub
#8. Me creo un Personal access token para poder acceder a ciertas tareas del repo desde otro lugar.
#    token-to-connect-to-github
#    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



# Los runners aparentemente son procesos que se encargan de realizar la tarea de ejecución de los pipeline, 
# GitLab tiene runners pero los mismos son compartidos entre usuarios, por eso es recomendable que tengamos nuestros propios runners.

# API TOKEN
# gitlab_lojack
# dop_v1_3c62636fd1ac8d7e96623ba5bb7bf3bb264686ce358ee943b0357c348041c266