#!/bin/bash

# Descarga un archivo mediante socks5 puerto 9050

url="http://ipv4.download.thinkbroadband.com:8080/5GB.zip"
output="5GB-d.zip"

while true; do
    curl --socks5-hostname localhost:9050 -C - "$url" -o "$output"

    # Verificar el código de salida de curl
    if [ $? -eq 0 ]; then
        echo "Descarga completada exitosamente."
        break
    else
        echo "Descarga interrumpida. Reintentando en 10 segundos..."
        sleep 10
    fi
done
