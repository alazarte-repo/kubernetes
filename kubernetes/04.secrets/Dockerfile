FROM gcr.io/google-samples/hello-app:1.0

# Pasos para subir una imagen en Docker Hub desde línea de comandos
# 1. Ejecutar "docker login" e ingresar usuario y contraseña
# 2. Nos dirigimos al directorio en donde se encuentra el Dockerfile y mediante linea de comandos tipeamos y ejecutamos "docker build ."

# Construir una imagen en docker
# Generar el archivo Dockerfile y correr dentro del directorio:
# docker build -t <usuario_dockerhub>/<nombre_imagen>:<tag> .
# docker build -t adriandockerimg/push_test:1.0 .

# Ver todas las imagenes
# docker images

# Eliminar una imagen en docker
# docker rmi --force imagen

# Correr una imagen en docker
# docker run -it push_test 
#   -it: interactivo (stdin) + tty (pseudo terminal).
#   -d: se utiliza por el comando Docker Run para arrancar en segundo plano
#   -p: se utiliza para mapear los puertos

# Subir una imagen al repositorio de Docker Hub 
# Aclaración I: El repo debe estar ya creado antes de pushear. 
# Aclaración II: Para fines prácticos el repositorio es privado a fines de poder autenticarnos mediante Secrets de Kubernetes
    # docker push adriandockerimg/push_test:1.0