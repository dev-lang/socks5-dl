#!/bin/bash

# Función para manejar errores
handle_error() {
    http_code=$1
    echo "Error: $( [ "$http_code" -eq 404 ] && echo "Archivo no encontrado" || echo "HTTP $http_code" )"
}

# Función para obtener el tamaño del archivo en el servidor
get_remote_size() {
    url=$1
    # Realizar una solicitud HEAD y obtener el código de estado HTTP y el encabezado Content-Length
    response=$(curl --socks5-hostname localhost:9050 -sI "$url")
    http_code=$(echo "$response" | grep HTTP | awk '{print $2}')
    size=$(echo "$response" | grep -i Content-Length | awk '{print $2}' | tr -d '\r')

    if [ "$http_code" -eq 200 ]; then
        if [ -n "$size" ]; then
            echo "$size"
        else
            echo "Error: No se pudo obtener el tamaño del archivo"
        fi
    elif [ "$http_code" -eq 000 ]; then
        echo "Error: No se pudo conectar al servidor"
    else
        handle_error "$http_code"
    fi
}

# Archivo que contiene las URLs
url_list="urls.txt"

# Leer el archivo de URLs línea por línea
while IFS= read -r url; do
    remote_size=$(get_remote_size "$url")

    if [[ "$remote_size" == "Error: "* ]]; then
        echo "No se pudo obtener el tamaño del archivo para $url: $remote_size"
    else
        echo "El tamaño del archivo en el servidor para $url es: $remote_size bytes"
    fi
done < "$url_list"

