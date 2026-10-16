#!/bin/bash

echo "A ajustar e otimizar o file PHP.ini..."
echo ""

PHP_INI="/etc/php.ini"

if [ ! -f "$PHP_INI" ]; then
    echo "Erro: O ficheiro $PHP_INI nao foi encontrado!"
    echo "Certifique-se de que o PHP esta instalado antes de rodar este script."
    exit 1
fi

echo ""
echo "A aplicar configuracoes em $PHP_INI..."
echo ""
sudo sed -i 's|^;*date.timezone =.*|date.timezone = Europe/Lisbon|g' "$PHP_INI"

sudo sed -i 's|^upload_max_filesize =.*|upload_max_filesize = 20M|g' "$PHP_INI"

sudo sed -i 's|^post_max_size =.*|post_max_size = 25M|g' "$PHP_INI"

sudo sed -i 's|^memory_limit =.*|memory_limit = 256M|g' "$PHP_INI"

echo ""
echo "   -> Configurações editadas com sucesso!"
echo ""

echo "A reiniciar o Apache para aplicar as alteracoes..."
sudo systemctl restart httpd

echo ""
echo "A validar as alteracoes em tempo real..."
echo ""

echo ""
echo "Valores ativos no PHP:"
php -r "echo 'date.timezone: ' . ini_get('date.timezone') . \"\n\";"
php -r "echo 'upload_max_filesize: ' . ini_get('upload_max_filesize') . \"\n\";"
php -r "echo 'post_max_size: ' . ini_get('post_max_size') . \"\n\";"
php -r "echo 'memory_limit: ' . ini_get('memory_limit') . \"\n\";"
echo ""

echo ""
echo "O PHP esta otimizado com sucesso!"
echo ""

