#!/bin/bash

# Función para obtener el tamaño del archivo en el servidor
get_remote_size() {
    url=$1
    remote_size=$(curl --socks5-hostname localhost:9050 -sI "$url" | grep -i Content-Length | awk '{print $2}' | tr -d '\r')
    echo $remote_size
}

url_list="urls.txt"

while IFS= read -r url; do
    remote_size=$(get_remote_size "$url")
    echo "El tamaño del archivo en el servidor para $url es: $remote_size bytes"
done < "$url_list"
