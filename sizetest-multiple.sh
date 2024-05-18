#!/bin/bash

# Función para obtener el tamaño del archivo en el servidor

handle_error() {
    http_code=$1
    echo "Error: $( [ "$http_code" -eq 404 ] && echo "Archivo no encontrado" || echo "HTTP $http_code" )"
}

get_remote_size() {
    url=$1
    response=$(curl --socks5-hostname localhost:9050 -sI -w "%{http_code} %{size_download}\n" -o /dev/null "$url")
    http_code=$(echo "$response" | awk '{print $1}')
    size=$(echo "$response" | awk '{print $2}')

    if [ "$http_code" -eq 200 ]; then
        echo "$size"
    elif [ "$http_code" -eq 000 ]; then
        echo "Error: No se pudo conectar al servidor"
    else
        handle_error "$http_code"
    fi
}

url_list="urls.txt"

while IFS= read -r url; do
    remote_size=$(get_remote_size "$url")

    if [[ "$remote_size" == "Error: "* ]]; then
        echo "No se pudo obtener el tamaño del archivo para $url $remote_size"
    else
        echo "El tamaño del archivo en el servidor para $url es: $remote_size bytes"
    fi
done < "$url_list"
