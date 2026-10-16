#!/bin/bash

MYSQL_PASSWORD="atec123"
BACKUP_DIR="/backups"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="${BACKUP_DIR}/backup_sistema_${DATA}.tar.gz"
TEMPORARY_FOLDER="/tmp/backup_db"

echo "Atualizacoes automaticas e backup do sistema"
echo ""

echo "A iniciar a atualizacao automatica de pacotes (DNF)..."
sudo dnf update -y
echo ""
echo "Atualizacao concluida com sucesso!"
echo ""

echo "A preparar diretorios e a extrair bases de dados..."
echo ""
sudo mkdir -p "${BACKUP_DIR}"
sudo mkdir -p "${TEMPORARY_FOLDER}"

sudo mysqldump -u root -p"${MYSQL_PASSWORD}" --all-databases --result-file="${TEMPORARY_FOLDER}/all_databases.sql" 2>/dev/null

if [ $? -ne 0 ]; then
    echo "Erro: Falha ao autenticar no MariaDB. Verifique a palavra-passe."
    sudo rm -rf "${TEMPORARY_FOLDER}"
    exit 1
fi

echo ""
echo "A criar ficheiro compactado em ${BACKUP_FILE}..."
sudo tar -czf "${BACKUP_FILE}" -C /var/www/html . -C "${TEMPORARY_FOLDER}" all_databases.sql

sudo rm -rf "${TEMPORARY_FOLDER}"

if [ -f "${BACKUP_FILE}" ]; then
    echo "   -> Backup local gerado com sucesso!"
else
    echo "Erro: Falha ao criar o ficheiro compactado."
    exit 1
fi

echo ""
echo "Sistema atualizado e protegido com sucesso!"
