#!/bin/bash

# Función para obtener el tamaño del archivo en el servidor
get_remote_size() {
    url=$1
    remote_size=$(curl --socks5-hostname localhost:9050 -sI "$url" | grep -i Content-Length | awk '{print $2}' | tr -d '\r')
    echo $remote_size
}

# URL del archivo para probar la función
url=""

# Llamar a la función y mostrar el tamaño del archivo
remote_size=$(get_remote_size "$url")
echo "El tamaño del archivo en el servidor es: $remote_size bytes"
