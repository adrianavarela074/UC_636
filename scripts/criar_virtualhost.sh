#!/bin/bash

DOMAIN="adrimari.pt"
SITE_FOLDER="/var/www/${DOMAIN}"

echo ""
echo "Criacao e configuracao de virtual host no apache"
echo ""

echo ""
echo "A criar a estrutura de diretorios para ${DOMAIN}..."
sudo mkdir -p "${SITE_FOLDER}"

echo ""
echo "A estruturar o ficheiro de configuracao no Apache..."
sudo tee /etc/httpd/conf.d/${DOMAIN}.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName ${DOMAIN}
    ServerAlias www.${DOMAIN}
    DocumentRoot ${SITE_FOLDER}/public_html
    ErrorLog ${SITE_FOLDER}/logs/error.log
    CustomLog ${SITE_FOLDER}/logs/access.log combined

    <Directory ${SITE_FOLDER}/public_html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

sudo tee "${SITE_FOLDER}/public_html/index.php" > /dev/null <<EOF
<?php
echo "<h1>Virtual Host '${DOMAIN}' configurado com sucesso!</h1>;"
echo "<p>Os ficheiros do seu site estao em: ${SITE_FOLDER}/public_html/</p>;"
?>
EOF

echo ""
echo "A aplicar permissoes e regras do SELinux..."
sudo chown -R apache:apache "${SITE_FOLDER}"
sudo chmod -R 755 "${SITE_FOLDER}"

sudo chcon -R -t httpd_sys_content_t "${SITE_FOLDER}/public_html" &> /dev/null

sudo chcon -R -t httpd_log_t "${SITE_FOLDER}/logs" &> /dev/null

echo ""
echo "A configurar a resolucao de nomes local em /etc/hosts..."
if grep -q "${DOMAIN}" /etc/hosts; then
    echo "O dominio ${DOMAIN} ja estava configurado em /etc/hosts."
else
    echo "127.0.0.1 ${DOMAIN} www.${DOMAIN}" | sudo tee -a /etc/hosts > /dev/null
    echo "   -> Linha adicionada com sucesso ao /etc/hosts!"
fi

echo ""
echo "A validar sintaxe e reiniciar o servidor..."
if sudo apachectl configtest; then
    sudo systemctl restart httpd
    echo " Virtual Host criado com sucesso para: http://${DOMAIN} "
else
    echo "Erro na sintaxe do Apache. Verifique as alteracoes."
fi

