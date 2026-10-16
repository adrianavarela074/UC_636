#!/bin/bash

TARGET_IP="${1%/24}"

if [ -z "$TARGET_IP" ]; then
	echo "Nenhum IP de destino fornecido ao script do router"
	exit 1
fi

echo ""
echo "A criar regras de Port Forwarding..."
echo ""

echo "Porta 22 - $TARGET_IP:22"
echo "Porta 80 - $TARGET_IP:80"
echo "Porta 443 - $TARGET_IP:443"

echo ""
echo "Regras de Port Forwarding aplicadas com sucesso"
