#!/bin/bash

DOMAIN=""
EMAIL="admin@$(hostname -f)"

echo ""
echo "A instalar mod_ssl certbot e utilitarios..."
echo ""

sudo dnf install mod_ssl certbot python3-certbot-apache bc -y

echo ""
echo "Ativar o mod_deflate e KeepAlive..."
echo ""

sudo cat <<EOF > /etc/httpd/conf.d/tuning.conf

KeepAlive On
MaxKeepAliveRequests 100
KeepAliveTimeout 5

Timeout 60

<IfModule mod_deflate.c>
	AddOutputFilterByType DEFLATE text/html text/plain test/xml text/css text/javascript application/javascript application/json
</IfModule>
EOF

echo "A calcular recursos de Hardware..."
echo ""
TOTAL_RAM=$(free -m | awk '/^Mem:/{print $2}')
MAX_CLIENTS=$(echo "$TOTAL_RAM * 0.7 / 45" | bc | cut -d. -f1)

if [ -z "$MAX_CLIENTS" ] || [ "$MAX_CLIENTS" -lt 10 ]; then
	MAX_CLIENTS=150
fi


echo ""
echo "RAM detetada: ${TOTAL_RAM}MB. MaxClients ajustado para: ${MAX_CLIENTS}"

sudo cat <<EOF > /etc/httpd/conf.d/mpm_tuning.conf

<IfModule mpm_event_module>
	StartServers		3
	MinSpareThreads		25
	MaxSpareThreads		75
	ThreadLimit		64
	ThreadsPerChild		25
	MaxRequestWorkers	${MAX_CLIENTS}
	MaxConnectionsPerChild	1000
</IfModule>
EOF

echo""
echo "A configurar a camada de segurança SSL/TLS..."
echo ""

if [ -n "$DOMAIN" ]; then
	echo "A tentar gerar certificado oficial Let's Encrypt para $DOMAIN..."
	sudo certbot --apache -d "$DOMAIN" --non-interactive --agree-tos --email "$EMAL" --redirect
else
	echo "Nenhum dominio configurado. A gerar certificado Auto-Assinado para testes..."

	sudo mkdir -p /etc/httpd/ssl
	sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/httpd/ssl/apache.key -out /etc/httpd/ssl/apache.crt -subj "/C=PT/ST=Lisboa/L=Lisboa/O=Atec/OU=TI/CN=localhost"

	sudo sed -i 's|SSLCertificateFile /etc/pki/tls/certs/localhost.crt|SSLCertificateFile /etc/httpd/ssl/apache.crt|g' /etc/httpd/conf.d/ssl.conf
	sudo sed -i 's|SSLCertificateKeyFile /etc/pki/tls/private/localhost.key|SSLCertificateKeyFile /etc/httpd/ssl/apache.key|g' /etc/httpd/conf.d/ssl.conf
fi

echo "A validar sintaxe e reiniciar o Apache..."

if sudo apachectl configtest; then
	sudo systemctl restart httpd
	echo "Apache otimizado, tunado e com SSL ativo com sucesso!"
else
	echo "Erro na sintaxe das configurações do Apache. Verificar os logs"
fi
