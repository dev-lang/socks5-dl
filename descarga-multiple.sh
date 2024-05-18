#!/bin/bash

# Descarga múltiples archivos mediante socks5 puerto 9050

url_list="urls.txt"

while IFS= read -r url; do
    filename=$(basename "$url")

    echo "Descargando $filename desde $url..."

    while true; do
        curl --socks5-hostname localhost:9050 -C - "$url" -o "$filename"

	# Verificar el código de salida de curl
        if [ $? -eq 0 ]; then
            echo "Descarga de $filename completada exitosamente."
            break
        else
            echo "Descarga de $filename interrumpida. Reintentando en 10 segundos..."
            sleep 10
        fi
    done
done < "$url_list"
