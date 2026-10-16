#!/bin/bash
CURRENT_MYSQL_PASSWORD="atec123"
NEW_MYSQL_PASSWORD="atec123"
echo " "
echo "A iniciar a configuracao segura do MariaDB..."
sudo mysql -u root -p"${CURRENT_MYSQL_PASSWORD}" <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${NEW_MYSQL_PASSWORD}';

DELETE FROM mysql.user WHERE User='';

DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost','127.0.0.1','::1');

DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';

FLUSH PRIVILEGES;
EOF

echo "Configuracao segura do MariaDB concluida com sucesso!"

