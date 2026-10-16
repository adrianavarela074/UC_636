#!/bin/bash
CURRENT_MYSQL_PASSWORD="atec123"
NEW_MYSQL_PASSWORD="atec123"

DB_NAME="bd_site"
DB_USER="user_site"
DB_PASS="atec123"

echo " "
echo "A iniciar a configuracao segura do MariaDB..."
sudo mysql -u root -p"${CURRENT_MYSQL_PASSWORD}" <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${NEW_MYSQL_PASSWORD}';

DELETE FROM mysql.user WHERE User='';

DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost','127.0.0.1','::1');

DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';

CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';

FLUSH PRIVILEGES;
EOF

echo ""
echo "Base de dados '${DB_NAME}' e utilizador '${DB_USER}' prontos!"
echo ""
echo "Configuracao segura do MariaDB concluida com sucesso!"

