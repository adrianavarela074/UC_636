#!/bin/bash

echo "A instalar o modulo ModSecurity e regras OWASP..."
echo ""
sudo dnf install mod_security mod_security_crs -y

echo "A configurar o ModSecurity para modo de bloqueio"
echo ""
sudo sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/g' /etc/httpd/conf.d/mod_security.conf

echo ""
echo "A reiniciar o servidor Apache..."
sudo systemctl restart httpd

sudo cat <<EOF > /var/www/html/index.php
<?php
echo "<h1>Servidor Web Seguro</h1>";
if (isset($_GET['test'])) {
	echo "<p>Parametro recebido: " . htmlspecialchars($_GET['test']) . "</p>";
}
EOF

echo ""
echo "A iniciar os testes de proteção contra ataques..."
echo ""
sleep 2

echo -n "Teste 1: SQL Injection (?id=1' OR 1=1) -> "
RESPONSE_SQLI=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost/index.php?id=1'%20OR%201=1")

if [ "$RESPONSE_SQLI" -eq 403 ]; then
	echo "Bloqueado com sucesso (403 Forbidden)"
else
	echo "Falhou (HTTP $RESPONSE_SQLI - o ataque passou!)"
fi

echo -n "Teste 2: Cross-Site Scripting (<script>) -> "
RESPONSE_XSS=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost/index.php?test=<script>alert(1)</script>")

if [ "$RESPONSE_XSS" -eq 403 ]; then
	echo "Bloqueado com sucesso (403 Forbidden)"
else
	echo "Falhou (HTTP $RESPONSE_XSS - o ataque passou)"
fi

echo ""
echo "O ModSecurity está ativo"
echo ""
