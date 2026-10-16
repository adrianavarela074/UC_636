#!/bin/bash
MYSQL_PASSWORD="atec123"

echo ""
echo "A iniciar o tuning e otimizacao do MariaDB..."
echo ""

sudo dnf install bc -y &> /dev/null

echo "A calcular recursos de Hardware para o MariaDB..."
echo ""
TOTAL_RAM_M=$(free -m | awk '/^Mem:/{print $2}')
INNODB_POOL_M=$(echo "$TOTAL_RAM_M * 0.60" | bc | cut -d. -f1)

if [ -z "$INNODB_POOL_M" ] || [ "$INNODB_POOL_M" -lt 128 ]; then
    INNODB_POOL_M=128
fi

echo "   -> RAM total detetada: ${TOTAL_RAM_M}M"
echo "   -> innodb_buffer_pool_size definido para 60%: ${INNODB_POOL_M}M"
echo ""

echo "A aplicar configuracoes de tuning em /etc/my.cnf.d/mariadb-server.cnf..."
echo ""

sudo tee /etc/my.cnf.d/tuning_mariadb.cnf > /dev/null <<EOF
[mysqld]
innodb_buffer_pool_size = ${INNODB_POOL_M}M
innodb_log_file_size = 256M
max_connections = 100
query_cache_size = 32M
EOF

echo "A reiniciar o servico MariaDB..."
echo ""
sudo systemctl restart mariadb

echo "A validar o desempenho e variaveis aplicadas..."
sleep 2
echo ""

echo "Resultados do Tuning na Memoria do MariaDB:"
echo ""
echo ""
sudo mysql -u root -p"${MYSQL_PASSWORD}" -e "SHOW VARIABLES LIKE 'innodb_buffer_pool_size';" | awk 'NR>1 {print "Pool Size: " $2/1024/1024 " MB"}'
sudo mysql -u root -p"${MYSQL_PASSWORD}" -e "SHOW VARIABLES LIKE 'innodb_log_file_size';" | awk 'NR>1 {print "Log File Size: " $2/1024/1024 " MB"}'
sudo mysql -u root -p"${MYSQL_PASSWORD}" -e "SHOW VARIABLES LIKE 'max_connections';" | awk 'NR>1 {print "Max Connections: " $2}'
sudo mysql -u root -p"${MYSQL_PASSWORD}" -e "SHOW VARIABLES LIKE 'query_cache_size';" | awk 'NR>1 {print "Query Cache Size: " $2/1024/1024 " MB"}'
echo ""

echo " MariaDB otimizado e a funcionar com performance maxima! "
