#!/bin/bash
echo "A instalar e a iniciar os servicos..."
sudo dnf install httpd php php-mysqlnd php-json php-gd php-mbstring mariadb-server -y
echo ""
sudo systemctl enable --now httpd
sudo systemctl enable --now mariadb
echo ""
echo "<?php phpinfo(); ?> Instalado com sucesso"| sudo tee /var/www/html/info.php
